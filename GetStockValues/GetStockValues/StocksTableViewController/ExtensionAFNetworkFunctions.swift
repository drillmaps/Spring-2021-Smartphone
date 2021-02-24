//
//  ExtensionAFNetworkFunctions.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 24/02/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import PromiseKit

extension StocksTableViewController {
    
    // MARK : get URL for all the Symbols in the Database
    func getUrl() -> String{
        var url = apiURL
        
        for symbol in symbolArr  {
            url.append(symbol + ",")
        }
        
        url = String( url.dropLast() )
        
        url.append("?apikey=")
        url.append(apiKey)
        
        return url
        
    }
    
    // MARK : Get URL for one Symbol
    func getUrlForSymbol(_ symbol : String) -> String {
        var url = apiURL
        url.append(symbol)
        url.append("?apikey=")
        url.append(apiKey)
        return url
    }
    
    func addStock(_ symbol: String ){
        // Get url for the symbol
        let url = getUrlForSymbol(symbol)
        
        getQuickShortQuote(url)
        .done { (stocks) in
            // If the stock symbol does not exist in NASDAQ
            if stocks.count == 0 {
                return
            }
            
            self.addStockToDB(stocks[0])
            self.symbolArr.append(stocks[0].symbol)

            // Update all the values and refresh the data
            self.getData();
        }
        .catch { (error) in
            print(error)
        }
        
        
        
    }
    
    // MARK: Get data for all the symbols and update the values in Database
    func getData(){
        
        if symbolArr.count == 0 {
            return
        }
        
        let url = getUrl()
        
        getQuickShortQuote(url)
            .done { (stocks) in
                self.stockArr = [Stock]()
                for stock in stocks {
                    self.stockArr.append(stock)
                }
                self.updateValuesInDB(stocks: self.stockArr)
                self.tblStocks.reloadData()
            }
            .catch { (error) in
                print("Error in getting all the stock values \(error)")
            }
    }// end of function
    
    
    @objc func getStockData(){
        getData()
        self.refreshControl?.endRefreshing()
    }
    
    
    func getQuickShortQuote(_ url : String) -> Promise<[Stock]>{
        
        return Promise<[Stock]> { seal -> Void in
            
            SwiftSpinner.show("Getting Stock Price")
            AF.request(url).responseJSON { response in
                SwiftSpinner.hide()
                if response.error == nil {
        
                    var arr  = [Stock]()
                    guard let data = response.data else {return seal.fulfill( arr ) }
                    guard let stocks = JSON(data).array else { return  seal.fulfill( arr ) }
                    
                    for stock in stocks {
                        
                        let symbol = stock["symbol"].stringValue
                        let price = stock["price"].floatValue
                        let volume = stock["volume"].intValue
                        
                        let stock = Stock()
                        stock.symbol = symbol
                        stock.price = price
                        stock.volume = volume
                        arr.append(stock)
                    }
                    
                    seal.fulfill(arr)
                }
                else {
                    seal.reject(response.error!)
                }
            }// end of AF request
        }//End of Promise return
    }// End of function
    
    
}// end of class

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
        
        SwiftSpinner.show("Getting Stock Price")
        
        AF.request(url).responseJSON { response in
            
           SwiftSpinner.hide()
            
            // If we get no error
            if response.error == nil {
                
                // get the data and stocks JSON array
                guard let data = response.data else {return}
                guard let stocks = JSON(data).array else { return }
                
                // If the stock symbol does not exist in NASDAQ
                if stocks.count == 0 {
                    return
                }
                
                
                // There should be just one value (atleast one value)
                let symbol = stocks[0]["symbol"].stringValue
                let price = stocks[0]["price"].floatValue
                let volume = stocks[0]["volume"].intValue
     
                
                let stock = Stock()
                stock.symbol = symbol
                stock.price = price
                stock.volume = volume
                
                self.addStockToDB(stock)
                self.symbolArr.append(symbol)
                
                // Update all the values and refresh the data
                self.getData();
                
            }// end of response.error == nil
            
        }// end of AF request
        
    }
    
    // MARK: Get data for all the symbols and update the values in Database
    func getData(){
        
        if symbolArr.count == 0 {
            return
        }
        
        let url = getUrl()
        
        SwiftSpinner.show("Getting Stock Values")
        
        AF.request(url).responseJSON { response in
            
           SwiftSpinner.hide()
            
            if response.error == nil {
                
                guard let data = response.data else {return}
                
                guard let stocks = JSON(data).array else { return }
                
                if stocks.count == 0 {
                    return
                }
                
                self.stockArr = [Stock]()
                
                for stock in stocks {
                    
                    let symbol = stock["symbol"].stringValue
                    let price = stock["price"].floatValue
                    let volume = stock["volume"].intValue
                    
                    let stock = Stock()
                    stock.symbol = symbol
                    stock.price = price
                    stock.volume = volume


                    self.stockArr.append(stock)
                }
                self.updateValuesInDB(stocks: self.stockArr)
                self.tblStocks.reloadData()
            }// end of response.error == nil
        }// end of AF request
    }// end of function
    
    
    @objc func getStockData(){
        getData()
        self.refreshControl?.endRefreshing()
    }
    
}

//
//  StocksTableViewController.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 17/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class StocksTableViewController: UITableViewController {

    var globalStockTxtField : UITextField?
    
    var symbolArr: [String] = [String]()
    
    var stockArr: [Stock] = [Stock]()
    
    @IBOutlet var tblStocks: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData();
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cell = Bundle.main.loadNibNamed("StockTableViewCell", owner: self, options: nil)?.first as! StockTableViewCell
        
        cell.lblSymbol.text = "\(stockArr[indexPath.row].symbol) "
        
        cell.lblPrice.text = "$\(stockArr[indexPath.row].price)"

        return cell
    }
    
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

                    self.stockArr.append(Stock(symbol: symbol , price: price, volume: volume))
                }
                
                self.tblStocks.reloadData()
            }// end of response.error == nil
            
        }// end of AF request
    }// end of function
    
    @IBAction func addStockSymbol(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Get Stock Price", message: "Type in The Symbol", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            guard let stock = self.globalStockTxtField?.text else {return}
            
            if stock == "" {
                return
            }
            
            self.symbolArr.append(stock)
            
            self.getData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
        }
        
        alert.addTextField { (stockTxtField) in
            stockTxtField.placeholder = "Type Stock Symbol"
            self.globalStockTxtField = stockTxtField
        }
        
        alert.addAction(OK)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

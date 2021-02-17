//
//  ViewController.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 10/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController {

    @IBOutlet weak var lblStockPrice: UILabel!
    
    var globalStockTxtField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getStockAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Get Stock Price", message: "Type in The Symbol", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            guard let stock = self.globalStockTxtField?.text else {return}
            
            if stock == "" {
                return
            }
            
            self.getStockValue(stock)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            //print("Cancel")
        }
        
        alert.addTextField { (stockTxtField) in
            stockTxtField.placeholder = "Type Stock Symbol"
            self.globalStockTxtField = stockTxtField
        }
        
        alert.addAction(OK)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getStockValue(_ stockSymbol : String){
        
        
        let url = getURL(stockSymbol)
        
        
        SwiftSpinner.show("Getting \(stockSymbol) Stock Value")
        AF.request(url).responseJSON { response in
            
            SwiftSpinner.hide()

            if response.error == nil {
                
                let stockData: JSON = JSON(response.data!)
                
                guard let stocks = stockData.array else {return}
                
                if stocks.count == 0 {
                    self.lblStockPrice.text = "Stock Symbol \(stockSymbol) does not exist"
                }
                                
                for stock in stocks {
                    self.lblStockPrice.text = "\(stock["symbol"].stringValue) : $\(stock["price"].floatValue)"
                }
                
            }
            else{
                print(response.error?.localizedDescription ?? "Error")
            }
            
        }
        
    }
    
    func getURL(_ stockSymbol : String) -> String {
        return apiURL + stockSymbol + "?apikey=" + apiKey
    }
}


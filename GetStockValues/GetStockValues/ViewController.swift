//
//  ViewController.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 10/02/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblStockPrice: UILabel!
    
    var globalStockTxtField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getStockAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Get Stock Price?", message: "Type in The Symbol", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            guard let stock = self.globalStockTxtField?.text else {return}
            
            self.getStockValue(stock)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("Cancel")
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
        
    }
    
    func getURL(_ stockSymbol : String) -> String {
        return apiURL + stockSymbol + "?apikey=" + apiKey
    }
}


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
import RealmSwift

class StocksTableViewController: UITableViewController {

    var globalStockTxtField : UITextField?
    
    var symbolArr: [String] = [String]()
    
    var stockArr: [Stock] = [Stock]()
    
    @IBOutlet var tblStocks: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStockValues()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getStockData), for: .valueChanged)
        self.refreshControl = refreshControl
        
//        do{
//            let _ = try Realm()
//
//        }catch{
//            print("Error in initializing realm")
//        }
//
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    
    @IBAction func addStockSymbol(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Get Stock Price", message: "Type in The Symbol", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            guard let symbol = self.globalStockTxtField?.text else {return}
            
            if symbol == "" {
                return
            }
            
            if self.doesStockExist(symbol: symbol) {
                return
            }
            
            // The stock was not existing so add stock in the DB and refresh the data in Table
            self.addStock(symbol)
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
    
//    override func tableView(_ tableView : UITableView, commit editingStyle: UITableViewCell.EditingStyle  , forRowAt indexPath: IndexPath){
//        
//        if editingStyle == .delete {
//            let stock =  stockArr[indexPath.row]
//            
//            deleteStockFromDB(stock)
//            stockArr.remove(at: indexPath.row)
//        
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            loadStockValues()
//
//        }
//    }
    

}

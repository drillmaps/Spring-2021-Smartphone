//
//  ExtensionTableVieFunctions.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 24/02/21.
//


import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift


extension StocksTableViewController {
    
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
    

    
}


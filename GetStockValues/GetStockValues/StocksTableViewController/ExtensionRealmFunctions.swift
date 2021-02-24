//
//  ExtensionRealmFunctions.swift
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
    
    // MARK: This function is called at startupand it loads the latest values from DB.
    func loadStockValues(){
        
        do {
            let realm = try Realm()
            let stocks = realm.objects(Stock.self)
            
            stockArr.removeAll()
            
            for stock in stocks {
                symbolArr.append(stock.symbol)
            }
            getData()
        }catch{
            print("Error in getting values from Database \(error)")
        }
        
    }
    
    // MARK: This function updates all the stock values in the Database
    func updateValuesInDB( stocks : [Stock]){
        
        do {
            let realm = try Realm()
            for stock in stocks {
                try realm.write {
                    realm.add(stock, update: .modified)
                }
            }
            
        }
        catch{
            print("Error in updating values in the database \(error)")
        }
        
        
    }
    
    // MARK: Checks if the stock symbol already exists in the Database
    func doesStockExist(symbol: String) -> Bool {
        let realm = try! Realm()
        if realm.object(ofType: Stock.self, forPrimaryKey: symbol) != nil {
            return true
        }
        
        return false
        
    }
    
    // MARK : This function adds stock in the Realm database
    func addStockToDB(_ stock: Stock){
        do{
            let realm = try Realm()
            
            try realm.write{
                realm.add(stock)
            }
        }catch{
            print("Error in initializing realm")
        }
    }
    
    func deleteStockFromDB(_ stock : Stock){
        
        do {
            let realm = try Realm()
            try realm.write({
                realm.delete(stock)
            })
        }
        catch{
            print(" I am here")
            print(error)
        }
       
    }
}

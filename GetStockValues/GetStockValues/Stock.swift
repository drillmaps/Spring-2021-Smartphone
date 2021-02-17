//
//  Stock.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 17/02/21.
//

import Foundation
import RealmSwift

class Stock: Object {
    @objc dynamic var symbol : String = ""
    @objc dynamic var price : Float = 0.0
    @objc dynamic var volume : Int = 0
    
    override static func primaryKey() -> String? {
        return "symbol"
    }

}

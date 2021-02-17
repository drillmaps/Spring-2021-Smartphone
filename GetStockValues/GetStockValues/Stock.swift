//
//  Stock.swift
//  GetStockValues
//
//  Created by Ashish Ashish on 17/02/21.
//

import Foundation

class Stock {
    var symbol : String = ""
    var price : Float = 0.0
    var volume : Int = 0
    
    init(symbol: String, price : Float, volume: Int) {
        self.symbol = symbol
        self.price = price
        self.volume = volume
    }
}

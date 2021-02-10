//
//  TableViewController.swift
//  TableViewXib
//
//  Created by Ashish Ashish on 10/02/21.
//

import UIKit

class TableViewController: UITableViewController {

    let stock = ["FB", "AMZN", "AAPL", "NTFX", "GOOG", "MSFT", "TSLA"]
    let values = ["269.45", "3,305.00", "136.01", "559.07", "2,083.51", "243.77", "849.46"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stock.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblStock.text = stock[indexPath.row]
        cell.lblValue.text = "$" +  values[indexPath.row]

        return cell
    }


}

//
//  BasketViewController.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

class BasketViewController: UITableViewController, BasketDelegate {
    
    let basket = Basket.shared
    
    override func viewDidLoad() {
        basket.delegate = self
        
        tableView.reloadData()
        tableView.rowHeight = 101
    }
    
    var sections: [String] {
        get {
            return Array(basket.orders.keys)
        }
    }
    
    func dataChanged() {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return basket.orders.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            let predicate = NSPredicate(format: "count > 0")
//            let itemsInBasket = Item.MR_findAllWithPredicate(predicate)
//            if let count = itemsInBasket?.count {
//                return count
//            }
//            else {
//                return 0
//            }
//        }
//        else {
//            let owner = getOwner(byIndex: section + 1)
//            return basket.orders[owner]!.count
//        }
        
        let sectionName = sections[section]
        return basket.orders[sectionName]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let orderItem = basket.orders[section]![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("imageOrderCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        cell.initFromItem(orderItem.item)
        if section != Constants.currentDeviceSection {
            cell.count.text = String(orderItem.count)
            cell.stepper.hidden = true
        }
        
        return cell
    }
}


















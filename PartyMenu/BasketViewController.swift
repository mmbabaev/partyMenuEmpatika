//
//  BasketViewController.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

//observer for "dataChanged"

class TotalBasketViewController: UITableViewController {
    
    var totalBasket: TotalBasket!
    
    override func viewDidLoad() {
        totalBasket = TotalBasket.shared
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateTable), name: NotificationNames.dataChanged, object: nil)
        
        tableView.reloadData()
        tableView.rowHeight = 101
    }
    
    var sections: [String] {
        return totalBasket.owners.map({
            if $0 == UIDevice.currentDevice().name {
                return Constants.currentDeviceSection
            }
            else {
                return $0
            }
        })
    }
    
    func updateTable() {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.totalBasket.coreDataChange()
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return totalBasket.baskets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalBasket.baskets[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] + String(" \(totalBasket.baskets[section].sum) ₽")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderItem = totalBasket[indexPath]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId.imageOrder, forIndexPath: indexPath) as! ItemTableViewCell
        
        cell.initFromItem(orderItem)
        cell.stepper.hidden = false
        
        if !totalBasket.isAdmin {
            print(sections[indexPath.section])
            if sections[indexPath.section] != Constants.currentDeviceSection {
                cell.stepper.hidden = true
            }
        }
        
        return cell
    }
}


















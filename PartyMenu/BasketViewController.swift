//
//  BasketViewController.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

class TotalBasketViewController: UITableViewController, TotalBasketDelegate {
    
    var totalBasket: TotalBasket!
    
    override func viewDidLoad() {
        totalBasket = TotalBasket.shared
        totalBasket.delegate = self
        
        let showAction = #selector(self.showSettings)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Подключение", style: .Plain, target: self, action: showAction)
        
        tableView.reloadData()
        tableView.rowHeight = 101
    }
    
    func showSettings() {
        performSegueWithIdentifier("showSettings", sender: self)
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
    
    func dataChanged() {
        NSOperationQueue.mainQueue().addOperationWithBlock({
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
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderItem = totalBasket[indexPath]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId.imageOrder, forIndexPath: indexPath) as! ItemTableViewCell
        
        cell.initFromItem(orderItem)
        
        if !totalBasket.isAdmin &&
            sections[indexPath.section] != Constants.currentDeviceSection {
            
            cell.count.text = String(orderItem.count)
            cell.stepper.hidden = true
        }
        
        return cell
    }
}


















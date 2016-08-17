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
    var makeOrderButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        totalBasket = TotalBasket.shared
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateTable), name: NotificationNames.dataChanged, object: nil)
        
        tableView.reloadData()
        tableView.rowHeight = 101
        
        makeOrderButton = UIBarButtonItem(title: ButtonTitles.makeOrder, style: .Plain, target: self, action: #selector(makeOrderClicked))
        navigationItem.rightBarButtonItem = makeOrderButton
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
            self.makeOrderButton.enabled = self.totalBasket.isAdmin
            self.tableView.reloadData()
        })
    }
    
    func makeOrderClicked() {
        let sums = totalBasket.baskets.map({ $0.sum })
        let totalSum = sums.reduce(0, combine: { $0 + $1 })
        
        let alertController = UIAlertController(title: "Подтверждение заказа", message: "Общая сумма заказа: \(totalSum) ₽\n Вы уверены, что хотите сделать заказ?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Отменить", style: .Cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "Заказать", style: .Default) {
            action in
            
            print(self.totalBasket.json)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        
        presentViewController(alertController, animated: true, completion: nil)
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


















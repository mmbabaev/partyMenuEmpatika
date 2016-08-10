//
//  BasketManager.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

protocol BasketDelegate {
    func dataChanged()
}

class Basket {
    
    var delegate: BasketDelegate?
    
    // [owner : [orderItem]]
    var orders = [String : [OrderItem]]()
    
    static let shared: Basket = Basket()
    
    init() {
        ConnectionManager.shared.delegate = self
        
        orders[Constants.currentDeviceSection] = OrderItem.itemsInBasket()
    }
    
    func receivedData(dictionary: [String : String]) {
        let itemId = dictionary["itemId"]!
        let count = Int(dictionary["count"]!)!
        let owner = dictionary["owner"]!
        
        let item = Item.MR_findFirstByAttribute("id", withValue: itemId)!
        
        if let ownerOrders = orders[owner] {
            let currentOrders = ownerOrders.filter({
                order in
                return order.item.id == itemId
            })
            
            if currentOrders.isEmpty {
                orders[owner]!.append(OrderItem(item: item, count: count))
            }
            else {
                currentOrders[0].count = count
                orders[owner] = ownerOrders.filter({
                    order in
                    return order.count != 0
                })
            }
        }
        else {
            orders[owner] = [OrderItem(item: item, count: count)]
        }
        
        delegate?.dataChanged()
    }
    
    func orderChanged(forItem item: Item) {
        var dict = item.getOrderInfo()
        var dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
        receivedData(dataToSend)
        
        dict["owner"] = UIDevice.currentDevice().name
        dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
        ConnectionManager.shared.sendToAllData(dataToSend)
    }
}

extension Basket: ConnectionManagerDelegate {
    func receivedData(data: NSData) {
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Dictionary<String, String>
        receivedData(dataDictionary)
    }
}
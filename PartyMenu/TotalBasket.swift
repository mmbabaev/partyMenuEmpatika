//
//  BasketManager.swift
//  PartyMenu
//
//  Created by Михаил on 12.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON
import TSMessages

// posts dataChange notification

class TotalBasket {
    
    var owner: String!
    var baskets = [Basket]()
    
    var admin = UIDevice.currentDevice().name {
        didSet {
            isAdmin = admin == UIDevice.currentDevice().name
        }
    }
    var isAdmin: Bool = true {
        didSet {
            if isAdmin == false {
                baskets = [Basket]()
            }
        }
    }
    
    var sum: Double {
        return baskets.reduce(0.0, combine: { $0 + $1.sum })
    }
    
    static let shared: TotalBasket = TotalBasket()
    
    init() {
        ConnectionManager.shared.delegate = self
        
        loadCoreDataBasket()
    }
    
    func loadCoreDataBasket() {
        baskets = [Basket]()
        
        let currentUserBasket = CurrentUserBasket()
        currentUserBasket.orders = OrderItem.itemsInBasket()
        
        if !currentUserBasket.isEmpty {
            baskets.append(currentUserBasket)
        }
    }
    
    func coreDataChange() {
        for item in Item.MR_findAll()! {
            (item as! Item).count = 0
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
        
        for basket in baskets {
            if basket.owner == UIDevice.currentDevice().name {
                for order in basket.orders {
                    order.item.count = order.count
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                }
            }
        }
    }
    
    func receivedData(dictionary: [String : String]) {
        let itemId = dictionary["itemId"]!
        let count = Int(dictionary["count"]!)!
        let owner = dictionary["owner"]!
        
        
        let item = Item.MR_findFirstByAttribute("id", withValue: itemId)!
        
        if owner == UIDevice.currentDevice().name {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                item.count = count
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()            }
        }
        
        let ownerBaskets = baskets.filter({ $0.owner == owner })
        if ownerBaskets.isEmpty {
            var basket: Basket!
            if owner == UIDevice.currentDevice().name {
                basket = CurrentUserBasket()
            }
            else {
                basket = UserBasket(owner: owner)
            }
            basket.orders.append(OrderItem(item: item, count: count, owner: owner))
            baskets.append(basket)
        }
        else {
            var ownerBasket = ownerBaskets.first!
            let ownersOrders = ownerBasket.orders
            
            let currentOrders = ownersOrders.filter({ $0.item.id == itemId })
            if currentOrders.isEmpty {
                ownerBasket.orders.append(OrderItem(item: item, count: count, owner: owner))
            }
            else {
                
                for order in ownerBasket.orders {
                    if order.item.id == itemId {
                        order.count = count
                        break
                    }
                }

                ownerBasket.orders = ownerBasket.orders.filter({
                    $0.count != 0
                })
                
                
                if ownerBasket.orders.isEmpty {
                    baskets = baskets.filter({
                        $0.owner != ownerBasket.owner
                    })
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.dataChanged, object: nil)
    }
    
    func orderChanged(order: OrderItem) {
        let dict = order.getOrderInfo()
        
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
        receivedData(dict)
        
        ConnectionManager.shared.sendToAllData(dataToSend)
    }
    
    var owners: [String] {
        return baskets.map({ $0.owner })
    }
    
    func basket(withOwner owner: String) -> Basket? {
        for basket in baskets {
            if basket.owner == owner {
                return basket
            }
        }
        
        return nil
    }
    
    subscript(indexPath: NSIndexPath) -> OrderItem {
        return baskets[indexPath.section].orders[indexPath.row]
    }
    
    var json: String {
        var orders = [Int : Int]()
        
        //fill orders
        for basket in baskets {
            for order in basket.orders {
                let id = Int(order.itemId!)!
                if let oldCount = orders[id] {
                    orders[id] = oldCount + order.count
                }
                else {
                    orders[id] = order.count
                }
            }
        }
        
        let jsonItems: [AnyObject] = orders.map ({
            (id, count) in
            let jsonItem: AnyObject = [
                "group_modifiers" : [],
                "single_modifiers" : [],
                "item_id" : id,
                "quantity" : count
            ]
            return jsonItem
        })
        
        orderDict["total_sum"] = self.sum
        orderDict["items"] = jsonItems
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(orderDict, options: .PrettyPrinted)
            return String(data: data, encoding: NSUTF8StringEncoding)!
        }
        catch {
            return ""
        }
    }
    
    func makeOrderCompleted(isSuccess: Bool, message: String) {
        if isSuccess {
            TSMessage.showNotificationInViewController(rootVC, title: "Заказ отправлен", subtitle: message, type: .Success)
            baskets = [Basket]()
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.dataChanged, object: nil)
        }
        else {
            TSMessage.showNotificationInViewController(rootVC, title: "Заказ не отправлен", subtitle: message, type: .Error)
        }
    }
}

extension TotalBasket: ConnectionManagerDelegate {
    func receivedData(data: NSData) {
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Dictionary<String, String>
        if dataDictionary["type"] == "data" {
            receivedData(dataDictionary)
        }
        else {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                let isSuccess = dataDictionary["success"] == "true"
                let message = dataDictionary["message"]!
                self.makeOrderCompleted(isSuccess, message: message)
            }
        }
    }
    
    func acceptInvitation(peerName: String) {
        admin = peerName
    }
    
    func lostConnection(peerName: String) {
        if peerName == admin {
            admin = UIDevice.currentDevice().name
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.dataChanged, object: nil)
    }
}

















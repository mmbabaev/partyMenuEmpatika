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



class TotalBasket {
    
    var owner: String!
    var baskets = [Basket]()
    var isAdmin: Bool = true {
        didSet {
            if isAdmin == false {
                baskets = [Basket]()
            }
        }
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
                print(ownerBasket.owner)
                print(ownerBasket.orders)
                
                for order in ownerBasket.orders {
                    if order.item.id == itemId {
                        print("item id : \(order)")
                        print("item title : \(item.title)")
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
        
        for basket in baskets {
            print(basket.owner)
            for order in basket.orders {
                print(order.item.title)
                print(order.item.id)
                print(order.count)
            }
            print()
        }
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.dataChanged, object: nil)
    }
    
    func orderChanged(order: OrderItem) {
        let dict = order.getOrderInfo()
        
        print("order changed dict: ")
        print(dict)
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
        receivedData(dict)
        
//        dict["owner"] = UIDevice.currentDevice().name
//        dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
        
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
}

extension TotalBasket: ConnectionManagerDelegate {
    func receivedData(data: NSData) {
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Dictionary<String, String>
        receivedData(dataDictionary)
    }
    
    func acceptInvitation() {
        isAdmin = false
    }
}

















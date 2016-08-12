//
//  BasketManager.swift
//  PartyMenu
//
//  Created by Михаил on 12.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

protocol TotalBasketDelegate {
    func dataChanged()
}

class TotalBasket {
    
    var delegate: TotalBasketDelegate?
    
    var owner: String!
    var baskets = [Basket]()
    var isAdmin: Bool = true {
        didSet {
            loadCoreDataBasket()
        }
    }
    
    static var shared: TotalBasket = TotalBasket()
    
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
    
    func receivedData(dictionary: [String : String]) {
        let itemId = dictionary["itemId"]!
        let count = Int(dictionary["count"]!)!
        let owner = dictionary["owner"]!
        
        let item = Item.MR_findFirstByAttribute("id", withValue: itemId)!
        
        let ownerBaskets = baskets.filter({ $0.owner == owner })
        if ownerBaskets.isEmpty {
            if owner == UIDevice.currentDevice().name {
                baskets.append(CurrentUserBasket())
            }
            else {
                baskets.append(UserBasket(owner: owner))
            }
        }
        else {
            var ownerBasket = ownerBaskets[0]
            let ownersOrders = ownerBasket.orders
            
            let currentOrders = ownersOrders.filter({ $0.item.id == itemId })
            if currentOrders.isEmpty {
                ownerBasket.orders.append(OrderItem(item: item, count: count, owner: owner))
            }
            else {
                currentOrders[0].count = count
                ownerBasket.orders = ownerBasket.orders.filter({
                    $0.count != 0
                })
            }
        }
        
        delegate?.dataChanged()
    }
    
    func orderChanged(order: OrderItem) {
        let dict = order.getOrderInfo()
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
        receivedData(dataToSend)
        
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
}

















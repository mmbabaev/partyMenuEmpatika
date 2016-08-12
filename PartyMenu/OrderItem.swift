//
//  OrderItem.swift
//  PartyMenu
//
//  Created by Михаил on 06.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

class OrderItem {

    var item: Item!
    var count: Int!
    var owner: String!
    
    init(item: Item, count: Int, owner: String) {
        self.item = item
        self.count = count
        self.owner = owner
    }
    
    init(item: Item) {
        self.item = item
        self.count = item.count as! Int
        self.owner = UIDevice.currentDevice().name
    }
    
    static func itemsInBasket() -> [OrderItem] {
        let itemsInBasketPredicate = NSPredicate(format: "count > 0")
        let itemsInBasket = Item.MR_findAllWithPredicate(itemsInBasketPredicate) as! [Item]
        let result = itemsInBasket.map({
            item in OrderItem(item: item)
        })
        
        return result
    }
    
    func getOrderInfo() -> [String : String] {
        var result = [String : String]()
        result["itemId"] = item.id!
        result["count"] = String(count)
        result["owner"] = owner
        
        return result
    }

}


















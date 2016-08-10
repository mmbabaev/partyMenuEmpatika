//
//  OrderItem.swift
//  PartyMenu
//
//  Created by Михаил on 06.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation

class OrderItem{

    var item: Item!
    var count: Int!
    
    init(item: Item, count: Int) {
        self.item = item
        self.count = count
    }
    
    init(item: Item) {
        self.item = item
        self.count = item.count as! Int
    }
    
    static func itemsInBasket() -> [OrderItem] {
        let itemsInBasketPredicate = NSPredicate(format: "count > 0")
        let itemsInBasket = Item.MR_findAllWithPredicate(itemsInBasketPredicate) as! [Item]
        let result = itemsInBasket.map({
            item in OrderItem(item: item)
        })
        
        return result
    }
}


















//
//  BasketManager.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit


protocol Basket {
    var orders: [OrderItem] { get set }
    var owner: String { get }
}

extension Basket {
    
    var sum: Double {
        var result = 0.0
        for order in orders {
            result += order.item.getPrice() * Double(order.count)
        }
        return result
    }
    
    var isEmpty: Bool {
        return orders.isEmpty
    }
    
    var count: Int {
        return orders.count
    }
}













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
    
    var sumString: String {
        return String(format: "%g  ₽", sum)
    }
    
    var sum: Double {
        let prices = orders.map({ $0.item.getPrice() * Double($0.count) })
        return prices.reduce(0, combine: { $0 + $1 })
    }
    
    var isEmpty: Bool {
        return orders.isEmpty
    }
    
    var count: Int {
        return orders.count
    }
}













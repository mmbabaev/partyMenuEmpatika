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
    var isEmpty: Bool {
        return orders.isEmpty
    }
    
    var count: Int {
        return orders.count
    }
}













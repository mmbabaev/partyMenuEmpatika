//
//  UserBasket.swift
//  PartyMenu
//
//  Created by Михаил on 12.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation

class UserBasket: Basket {
    var owner: String
    var orders: [OrderItem] = [OrderItem]()
    
    init(owner: String) {
        self.owner = owner
    }
}
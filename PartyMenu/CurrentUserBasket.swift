//
//  CurrentUserBasket.swift
//  PartyMenu
//
//  Created by Михаил on 12.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CurrentUserBasket: Basket {
    var owner: String = UIDevice.currentDevice().name
    var orders = [OrderItem]()
    
    init() {}
}
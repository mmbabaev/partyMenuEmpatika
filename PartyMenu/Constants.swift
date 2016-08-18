//
//  Constants.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import UIKit

struct NotificationNames {
    static let connectedDevicesChanged = "connectedDevicesChanges"
    static let foundDevicesChanged = "foundDevicesChanges"
    static let dataChanged = "dataChanged"
}

struct CellId {
    static let imageOrder = "imageOrderCell"
    static let peer = "peerCell"
    static let imageItem = "imageItemCell"
    static let imageCategory = "imageCategoryCell"
    static let foundPeer = "foundPeerCell"
}

struct ButtonTitles {
    static let makeOrder = "Заказать"
}

struct Constants {
    static let currentDeviceSection = "Мое"
}

var rootVC: UIViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    return (appDelegate.window?.rootViewController)!
}

var orderDict = [
    "delivery_type": 0,
    "order_gifts": [  ],
    "total_sum": 280,
    "venue_id": 4852998169690112,
    "device_type": 0,
    "comment": "",
    "client": [
        "email": "",
        "id": 123158,
        "phone": "79999999999",
        "groups": [
            "lihniedannie": [
                "datarozdenia": "",
                "pol": "Мужской",
                "hislovoepole": "",
                "strokovoepole": ""
            ]
        ],
        "name": "Иван"
    ],
    "delivery_slot_id": 5707702298738688,
    "gifts": [
        
    ],
    "payment": [
        "type_id": 0,
        "wallet_payment": 0
    ],
    "extra_order_field": [
        "gruppa": [
            "strokovoenazakaz": "",
            "hislovoenazakaz": ""
        ]
    ],
    "items": [
        [
            "group_modifiers": [
                
            ],
            "item_id": 5707648880082944,
            "quantity": 2,
            "single_modifiers": [
                
            ]
        ]
    ],
    "delivery_sum": 0,
    "num_people": 1
]
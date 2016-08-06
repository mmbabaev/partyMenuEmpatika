//
//  Item.swift
//  
//
//  Created by Михаил on 06.08.16.
//
//

import Foundation
import CoreData
import MagicalRecord
import SwiftyJSON

@objc(Item)
class Item: NSManagedObject {
    static func create(fromJson json: JSON) -> Item {
        let item = Item.MR_createEntity()!
        item.title = json["title"].stringValue
        item.dishDescription = json["description"].stringValue
        item.id = json["id"].stringValue
        item.price = json["price"].double
        item.imageUrl = json["pic"].string
        
        return item
    }
}

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
        item.price = json["price"].doubleValue
        item.imageUrl = json["pic"].stringValue
        item.count = 0
        
        return item
    }
    
    func getOrderInfo() -> [String : String] {
        var result = [String : String]()
        result["itemId"] = id!
        result["count"] = String(Int(count!))
        result["owner"] = Constants.currentDeviceSection
        
        return result
    }
    
    func getCount() -> Int {
        return Int(count!)
    }
}
//
//  Category.swift
//  
//
//  Created by Михаил on 06.08.16.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Category)
class Category: NSManagedObject {
    
    func getSubdirectoriesArr() -> [Category] {
        return subCategories?.allObjects as! [Category]
    }
    
    func getItemsArr() -> [Item] {
        return items?.allObjects as! [Item]
    }
    
    static var roots: [Category] {
        get {
            if let roots = Category.MR_findByAttribute("isRoot", withValue: true) {
                let result = roots.map({
                    root in
                    return root as! Category
                })
                return result.sort({ $0.title < $1.title })
            }
            else {
                return [Category]()
            }
        }
    }
    
    static func create(fromJson json: JSON) -> Category {
        let category = MR_createEntity()!
        let info = json["info"]
        category.id = info["category_id"].stringValue
        category.imageUrl = info["pic"].string
        category.title = info["title"].stringValue
        
        let subCategories = json["categories"].arrayValue.map({
            jsonSubCategory in
            return Category.create(fromJson: jsonSubCategory)
        })
        category.subCategories = NSSet(array: subCategories)
        
        let items = json["items"].arrayValue.map({
            jsonItem in
            return Item.create(fromJson: jsonItem)
        })
        
        category.items = NSSet(array: items)
        category.isRoot = false
        
        return category
    }
}

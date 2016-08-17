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
        print(items)
        print(items?.count)
        print(items?.allObjects.count)
        return items?.allObjects as! [Item]
    }
    
    static var roots: [Category] {
        get {
            if let roots = Category.MR_findByAttribute("isRoot", withValue: true) {
                    return roots.map({
                        root in
                        return root as! Category
                    })
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
        print("\(category.title) - \(category.items!.count) ")
        category.isRoot = false
        
        return category
    }
}

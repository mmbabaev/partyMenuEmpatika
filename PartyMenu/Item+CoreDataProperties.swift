//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Михаил on 06.08.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var title: String?
    @NSManaged var dishDescription: String?
    @NSManaged var price: NSNumber?
    @NSManaged var imageUrl: String?
    @NSManaged var id: String?

}

//
//  Category+CoreDataProperties.swift
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

extension Category {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var imageUrl: String?
    @NSManaged var items: NSSet?
    @NSManaged var subCategories: NSSet?
    @NSManaged var isRoot: NSNumber?
}

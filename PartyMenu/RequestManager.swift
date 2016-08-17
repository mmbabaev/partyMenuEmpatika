//
//  DataManager.swift
//  PartyMenu
//
//  Created by Михаил on 06.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MagicalRecord

class RequestManager {
    static let menuUrl = "http://testappall.1.doubleb-automation-production.appspot.com/api/menu"
    
    static func loadJson(completeBlock: () -> Void) {

        Alamofire.request(.GET, menuUrl, parameters: [String:String]())
            .responseJSON { response in
                let json = JSON(data: response.data!)
                let rootCategories = json["menu"].arrayValue.map({
                    jsonRootCategory in
                    let rootCategory = Category.create(fromJson: jsonRootCategory)
                    rootCategory.isRoot = true
                })
                
                print(rootCategories.count)
                
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                print("end")
                completeBlock()
        }
    }
    
    static func makeOrder(jsonOrder: String, completeBlock: () -> Void) {
        let params = ["order" : jsonOrder]
        
    }
}


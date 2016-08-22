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
    static let menuUrl      = "http://testappall.1.doubleb-automation-production.appspot.com/api/menu"
    static let makeOrderUrl = "http://testappall.1.doubleb-automation-production.appspot.com/api/order?client_id=123158"
    
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
                completeBlock()
        }
    }
    
    static func makeOrder(jsonOrder: String, completeBlock: (Bool, String) -> Void) {
        let params = [
            "order" : jsonOrder
        ]
        
        
        Alamofire.request(.POST, makeOrderUrl, parameters: params).responseJSON {
            response in
            var dict = ["type" : "order"]
            
            if let result = response.result.value  {
                let json = JSON(result)
                
                let isSuccess = json["message"].stringValue == "Заказ отправлен"
                if isSuccess {
                    dict["success"] = "true"
                }
                else {
                    dict["success"] = "false"
                }
                
                let message = json["description"].stringValue
                dict["message"] = message
                completeBlock(isSuccess, message)
            }
            else {
                NSLog("request error: \(response.result.error!.localizedDescription)")
                dict["isSuccess"] = "Ошибка"
                dict["message"] = "."
                completeBlock(false, ".")
            }
            
            let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dict)
            ConnectionManager.shared.sendToAllData(dataToSend)
        }
    }
}


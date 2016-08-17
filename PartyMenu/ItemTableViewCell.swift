//
//  ItemTableViewCell.swift
//  PartyMenu
//
//  Created by Михаил on 06.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

class ItemTableViewCell: UITableViewCell {
    
    var orderItem: OrderItem!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var count: UILabel!
    
    func initFromItem(orderItem: OrderItem) {
        for label in [title, price, count, owner] {
            label.adjustsFontSizeToFitWidth = true
        }
        self.orderItem = orderItem
        
        let item = orderItem.item
        title.text = item.title
        if let priceValue = item.price {
            price.text = "\(priceValue) ₽"
        }
        else {
            price.text = "-"
        }
        
        dishDescription.text = item.dishDescription
        
        count.text = String(orderItem.count)
        stepper.value = Double(orderItem.count)
        
        // make count label circular and add border:
        count.layer.cornerRadius = count.frame.size.height / 2
        count.layer.masksToBounds = true
        count.layer.borderColor = UIColor.blackColor().CGColor
        count.layer.borderWidth = 3
        
        owner.text = ""
        
        stepper.addTarget(self, action: #selector(self.orderValueChanged), forControlEvents: .ValueChanged)
    }
    
    func orderValueChanged(sender: UIStepper) {
        count.text = String(Int(stepper.value))
        if orderItem.owner == UIDevice.currentDevice().name {
            self.orderItem.item.count = self.stepper.value
        }
        
        orderItem.count = Int(self.stepper.value)
        TotalBasket.shared.orderChanged(orderItem)
    }
}

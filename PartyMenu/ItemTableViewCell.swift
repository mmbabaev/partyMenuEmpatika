//
//  ItemTableViewCell.swift
//  PartyMenu
//
//  Created by Михаил on 06.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    var item: Item!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var count: UILabel!
    
    func initFromItem(item: Item) {
        for label in [title, price, count, owner] {
            label.adjustsFontSizeToFitWidth = true
        }
        
        self.item = item
        title.text = item.title
        price.text = "\(item.price!) $"
        dishDescription.text = item.dishDescription
        count.text = "0"
        owner.text = ""
        stepper.value = 0
        stepper.addTarget(self, action: #selector(self.orderValueChanged), forControlEvents: .ValueChanged)
    }
    
    func orderValueChanged(sender: UIStepper) {
        
    }
}

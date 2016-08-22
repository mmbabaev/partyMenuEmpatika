//
//  ViewController.swift
//  PartyMenu
//
//  Created by Михаил on 06.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import UIKit
import MagicalRecord
import SwiftyJSON
import AlamofireImage
import Alamofire

struct Sections {
    static let items = 0
    static let categories = 1
}

//observer for "dataChanged"

class MenuViewController: UITableViewController {
    
    var isRoot = true
    var categories = [Category]()
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateTable), name: NotificationNames.dataChanged, object: nil)
        
        if isRoot {
            title = "Меню"
            initRoots()
        }
        
        tableView.rowHeight = 101
    }
    
    
    func initRoots() {
        if Category.roots.isEmpty {
            RequestManager.loadJson() {
                self.categories = Category.roots
                self.updateTable()
            }
        }
        else {
            categories = Category.roots
            updateTable()
        }
    }
    
    func updateTable() {
        NSOperationQueue.mainQueue().addOperationWithBlock() {
            TotalBasket.shared.coreDataChange()
            self.items = self.items.map({
                let item = Item.MR_findFirstByAttribute("id", withValue: $0.id!)!
                return item
            })
            self.items = self.items.sort({ $0.title < $1.title })
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTable()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == Sections.items {
            let id = CellId.imageItem
            let cell = tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! ItemTableViewCell
            
            let item = items[indexPath.row]
            cell.initFromItem(OrderItem(item: item))
            
            let count = item.getCount()
            cell.stepper.value = Double(count)
            cell.count.text = String(count)
            
            if let url = item.imageUrl  {
                if url != "" {
                    Alamofire.request(.GET, url).responseImage {
                        response in
                        cell.picture?.contentMode = .ScaleAspectFill
                        cell.picture?.image = response.result.value
                    }
                }
            }

            return cell
        }
        else {
            let id = CellId.imageCategory
            let cell = tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! CategoryTableViewCell
            let category = categories[indexPath.row]
            cell.title.text = category.title
            cell.category = category
            cell.title.adjustsFontSizeToFitWidth = true
            
            if let url = category.imageUrl {
                if url != "" {
                    Alamofire.request(.GET, url).responseImage {
                        response in
                        cell.picture?.contentMode = .ScaleAspectFill
                        cell.picture?.image = response.result.value
                    }
                }
            }
            
            return cell
        }
    }
    
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Sections.categories {
            return "Категории"
        }
        else {
            return "Позиции"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.categories {
            return categories.count
        }
        else {
            return items.count
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == Sections.items {
            return nil
        }
        else {
            return indexPath
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == Sections.categories
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            if let parentCategory = (sender as! CategoryTableViewCell).category {
                let vc = segue.destinationViewController as! MenuViewController
                vc.items = parentCategory.getItemsArr().sort({ $0.title < $1.title })
                vc.categories = parentCategory.getSubdirectoriesArr()
                vc.isRoot = false
                vc.title = parentCategory.title
            }
        }
    }
}


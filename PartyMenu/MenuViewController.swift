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

class Sections {
    static let items = 0
    static let categories = 1
}

class MenuViewController: UITableViewController {
    
    var isRoot = true
    var categories = [Category]()
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let showAction = #selector(self.showConnections)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Подключение", style: .Plain, target: self, action: showAction)
        
        if isRoot {
            title = "Меню"
            initRoots()
        }
        
        tableView.rowHeight = 101
    }
    
    
    func initRoots() {
        if Category.roots.isEmpty {
            DataManager.loadJson() {
                self.categories = Category.roots
                self.tableView.reloadData()
            }
        }
        else {
            categories = Category.roots
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == Sections.items {
            let cell = tableView.dequeueReusableCellWithIdentifier("imageItemCell", forIndexPath: indexPath) as! ItemTableViewCell
            let item = items[indexPath.row]
            cell.initFromItem(item)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCategoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
            let category = categories[indexPath.row]
            cell.title.text = category.title
            cell.category = category
            cell.title.adjustsFontSizeToFitWidth = true
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
                vc.items = parentCategory.getItemsArr()
                vc.categories = parentCategory.getSubdirectoriesArr()
                vc.isRoot = false
                vc.title = parentCategory.title
            }
        }
        if segue.identifier == "showSettings" {
            print("show settings segue")
        }
    }
    
    func showConnections() {
        performSegueWithIdentifier("showSettings", sender: self)
    }
}


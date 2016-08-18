//
//  ConnectionsViewController.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import UIKit

class ConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var mcManager: ConnectionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        mcManager = ConnectionManager.shared
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateTable), name: NotificationNames.connectedDevicesChanged, object: nil)
    }
    
    func updateTable() {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
        })
    }
    
    @IBAction func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mcManager.connectedDevices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId.peer, forIndexPath: indexPath)
        cell.textLabel!.text = mcManager.connectedDevices[indexPath.row]
        return cell
    }
}

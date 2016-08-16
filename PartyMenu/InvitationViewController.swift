//
//  InvitationViewController.swift
//  PartyMenu
//
//  Created by Михаил on 12.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InvitationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedPeers = [MCPeerID]() {
        didSet {
            self.navigationItem.rightBarButtonItem?.enabled =
                !selectedPeers.isEmpty
        }
    }
    var manager: ConnectionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = ConnectionManager.shared
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setEditing(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateTable), name: NotificationNames.foundDevicesChanged, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Пригласить", style: .Plain, target: self, action: #selector(invitePeers))
        navigationItem.rightBarButtonItem?.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        manager.foundPeers = [MCPeerID]()
        manager.browser.startBrowsingForPeers()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        manager.browser.stopBrowsingForPeers()
    }
    
    func invitePeers() {
        for peer in selectedPeers {
            manager.browser.invitePeer(peer, toSession: manager.session, withContext: nil, timeout: 10)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateTable() {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId.foundPeer, forIndexPath: indexPath)
        let peer = manager.foundPeers[indexPath.row]
        cell.textLabel?.text = peer.displayName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let peer = manager.foundPeers[indexPath.row]

        selectedPeers.append(peer)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let peer = manager.foundPeers[indexPath.row]
        
        selectedPeers = selectedPeers.filter({
            $0 != peer
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.foundPeers.count
    }
}

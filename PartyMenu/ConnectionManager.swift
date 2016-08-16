//
//  ConnectionManager.swift
//  PartyMenu
//
//  Created by Михаил on 07.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    func receivedData(data: NSData)
    func acceptInvitation()
}

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
    var appServiceType = "party-menu"
    var session: MCSession!
    var devicePeerId: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var invitationHandler: ((Bool, MCSession) -> Void)!
    
    var delegate: ConnectionManagerDelegate?
    
    var foundPeers = [MCPeerID]()
    
    override init() {
        super.init()
        
        devicePeerId = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        session = MCSession(peer: devicePeerId)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: devicePeerId, serviceType: appServiceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: devicePeerId, discoveryInfo: nil, serviceType: appServiceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    deinit {
        //advertiser.stopAdvertisingPeer()
        //browser.stopBrowsingForPeers()
    }
    
    var connectedDevices: [String] {
        get {
            return session.connectedPeers.map({
                peer in
                return peer.displayName
            })
        }
    }
    
    func sendToAllData(data: NSData) {
        do {
            try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
        }
        catch let error as NSError {
            print("SEND TO ALL ERROR : \(error.localizedDescription)")
        }
    }
    
//    func acceptInvitation() {
//        self.invitationHandler(true, session)
//        invitationHandler(true, session)
//    }
//    
//    func declineInvitation() {
//        invitationHandler(false, nil)
//    }
}

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("MC LOG: found peer: \(peerID.displayName)")
        
        foundPeers.append(peerID)
        sendFoundDevicesChangedNotification()
        
        //browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 20)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        foundPeers = foundPeers.filter({
            $0 != peerID
        })
        
        sendFoundDevicesChangedNotification()
        print("MC LOG: lost peer \(peerID.displayName)")
    }
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
//        self.invitationHandler = invitationHandler
//        
//        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
        
        //TODO: change this
        print("invitation from peer : \(peerID.displayName)")
        delegate?.acceptInvitation()
        invitationHandler(true, self.session)
    }
}

extension ConnectionManager: MCSessionDelegate {
    
    func sendFoundDevicesChangedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.foundDevicesChanged, object: nil)
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        var event: String
        switch state {
        case .Connected:
            event = "Connected"
            foundPeers.append(peerID)
            sendFoundDevicesChangedNotification()
            
        case .Connecting:
            event = "Connecting"
            
        case .NotConnected:
            event = "Not connected"
            foundPeers = foundPeers.filter({
                $0 != peerID
            })
            sendFoundDevicesChangedNotification()
        }
        
        print("MC LOG: \(peerID.displayName) \(event)")
            
        let notification = NotificationNames.connectedDevicesChanged
        
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        delegate?.receivedData(data)
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress)
    {}
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {}
}
//
//  HubInterfaceExtension.swift
//  House
//
//  Created by Shaun Merchant on 20/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore


// MARK: - Switch Control
extension HouseExtension: HubInterfaceDelegate {
    
    public func eventDidOccur(of eventType: HubEvent, in domain: HubDomain) {
        guard self.conforms(to: .hubInterface) else {
            Log.debug("Attempted to delegate hub information to \(self.identifier), however it is not a hub interface.", in: .category)
            return
        }
        Log.debug("Delegating \(self.identifier) hub information: \(eventType) in \(domain).", in: .category)
        
        switch domain {
        case .houseExtension(let identifier):
            switch eventType {
            case .removed:
                let service = ServiceBundle(package: 100, service: 10, data: identifier.archive())!
                let message = Message(to: self.identifier, bundle: service)
                HouseDevice.current().messageOutbox.add(message: message)
            case .updated:
                return
                //guard let device = House.extensions.findExtension(with: identifier) else {
                    Log.debug("> Could not retrieve House Extension for event. Likely out of sync issue.", in: .category)
                  //  return
                //}
                //let deviceArchive = device.archive()
                //let service = ServiceBundle(package: 100, service: 11, data: deviceArchive)!
                //let message = Message(to: self.identifier, bundle: service)
                //HouseDevice.current().messageOutbox.add(message: message)
            }
        case .room(let name):
            switch eventType {
            case .removed:
                let nameData = name.archive()
                let data = nameData.count.archive() + nameData
                let service = ServiceBundle(package: 100, service: 12, data: data)!
                let message = Message(to: self.identifier, bundle: service)
                HouseDevice.current().messageOutbox.add(message: message)
            case .updated:
                guard let room = House.rooms.findRoom(called: name) else {
                    Log.debug("> Could not retrieve Room for event. Likely out of sync issue.", in: .category)
                    return
                }
                let roomArchive = room.archive()
                let service = ServiceBundle(package: 100, service: 13, data: roomArchive)!
                let message = Message(to: self.identifier, bundle: service)
                HouseDevice.current().messageOutbox.add(message: message)
            }
        }
        
    }

}

//
//  EventAutomationRule.swift
//  House
//
//  Created by Shaun Merchant on 09/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore 

/// An automation that is executed upon an event trigger.
public struct EventAutomation: Automation {
    
    /// The domain for the event automation.
    public let domain: Domain
    
    /// The characteristic the event automation responds to.
    public let characteristic: Characteristic
    
    public var label: String
    
    /// The closure to execute when requested to perform.
    fileprivate let actionBlock: (Extension) -> ()
    
    /// Create an automation that reponds to a change in characteristic.
    ///.
    /// - Parameters:
    ///   - name: The name of the automation.
    ///   - characteristic: The characteristic to observe for changes.
    ///   - responder: The domain of the characteristic change, i.e. whether to respond to changes in a specific House Extension, or a room.
    ///   - actionBlock: The closure to perform when the characteristic changes, recieving the House Extension that caused the event.
    public init(_ name: String, when characteristic: Characteristic, changesIn domain: Domain, perform actionBlock: @escaping (Extension) -> ()) {
        self.label = name
        self.characteristic = characteristic
        self.domain = domain
        self.actionBlock = actionBlock
    }
    
    /// Create an automation that responds to a change in characteristic of a specific House Extension.
    ///
    /// - Parameters:
    ///   - name: The name of the automation.
    ///   - characteristic: The characteristic to observe for changes.
    ///   - houseIdentifier: The House Identifier of the House Extension to observe for changes in the characteristic.
    ///   - actionBlock: The closure to perform when the characteristic changes, recieving the House Extension that caused the event.
    public init(_ name: String, when characteristic: Characteristic, changesIn houseIdentifier: HouseIdentifier, perform actionBlock: @escaping(Extension) -> ()) {
        self.init(name, when: characteristic, changesIn: EventAutomation.Domain.houseExtension(identifier: houseIdentifier), perform: actionBlock)
    }
    
    /// Create an automation that responds to a change in characteristic of any House Extension in a specific room.
    ///
    /// - Parameters:
    ///   - name: The name of the automation
    ///   - characteristic: The characteristic to observe for changes.
    ///   - roomName: The name of the room to observe for changes in characteristic.
    ///   - actionBlock: The closure to perform when the characteristic changes, recieving the House Extension that caused the event.
    public init(_ name: String, when characteristic: Characteristic, changesIn roomName: String, perform actionBlock: @escaping(Extension) -> ()) {
        self.init(name, when: characteristic, changesIn: EventAutomation.Domain.roomExtensions(called: roomName), perform: actionBlock)
    }
    
    public func perform() {
        // We can't perform without the Extension trigger. 
        // An odd case. Bad engineering I know.
    }

    
    /// The domain to observe for events.
    public enum Domain {
        /// Observe for events in a specific House Extension.
        case houseExtension(identifier: HouseIdentifier)
        /// Observe for events in any House Extension contained within a room.
        case roomExtensions(called: String)
        /// Observe for events in any House Extension known on the network.
        case anyExtension
    }
    
}

extension EventAutomation {
    
    public func handleEvent(from device: Extension, forCharacteristicChange characteristic: Characteristic, inRoom roomName: String? = nil) {
        guard characteristic == self.characteristic else {
            return
        }
        
        switch self.domain {
        case .anyExtension:
            self.actionBlock(device)
        case .houseExtension(let identifier):
            if identifier == device.identifier {
                self.actionBlock(device)
            }
        case .roomExtensions(let name):
            guard let roomName = roomName else {
                return
            }
            if name == roomName {
                self.actionBlock(device)
            }
        }
    }
    
}

//
//  Events.swift
//  House
//
//  Created by Shaun Merchant on 09/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// A structure to perform automationts that respond to events that occur across the House Network.
public struct Events {
    
    /// Perform automations that respond to a characteristic change in a House Extension.
    ///
    /// - Parameters:
    ///   - device: The House Extension that contains the charactersitic value that changed.
    ///   - characteristic: The characterstic whose value has changed.
    func characteristicValueDidChange(in device: Extension, for characteristic: Characteristic) {
        Log.debug("Event did occur in: \(device) for characteristic: \(characteristic)", in: .events)
        
        let deviceRoom = House.rooms.findRoom(with: device)
        
        for automation in House.automation {
            if let eventAutomation = automation as? EventAutomation {
                eventAutomation.handleEvent(from: device, forCharacteristicChange: characteristic, inRoom: deviceRoom?.name)
            }
        }
        
    }
    
}

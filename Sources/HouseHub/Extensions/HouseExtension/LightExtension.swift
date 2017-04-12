//
//  LightController.swift
//  House
//
//  Created by Shaun Merchant on 16/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

// MARK: - Light Control
extension HouseExtension: LightControllerDelegate {
    
    public func turnOnLight() {
        guard self.conforms(to: .lightController) else {
            Log.debug("Attempted to turn on \(self.identifier), however it is not a light.", in: .category)
            return
        }
        
        Log.debug("Extension \(self.identifier) is turning light on.", in: .category)
        
        let turnOnService = ServiceBundle(package: 111, service: 1, data: Date().archive())!
        let message = Message(to: self.identifier, bundle: turnOnService)
        
        HouseDevice.current().messageOutbox.add(message: message, expiresAt: Date().addingTimeInterval(5))
    }
    
    public func turnOffLight() {
        guard self.conforms(to: .lightController) else {
            Log.debug("Attempted to turn off \(self.identifier), however it is not a light.", in: .category)
            return
        }
        
        Log.debug("Extension \(self.identifier) is turning light off.", in: .category)
        
        let turnOffService = ServiceBundle(package: 111, service: 2, data: Date().archive())!
        let message = Message(to: self.identifier, bundle: turnOffService)
        
        HouseDevice.current().messageOutbox.add(message: message, expiresAt: Date().addingTimeInterval(5))
    }
    
    public func didRequestLightStatus() {
        guard self.conforms(to: .lightController) else {
            Log.debug("Attempted to get light status of \(self.identifier), however it is not a light.", in: .category)
            return
        }
        
        Log.debug("Extension \(self.identifier) requesting light status", in: .category)
        
        let statusRequestService = ServiceBundle(package: 111, service: 2)!
        let message = Message(to: self.identifier, bundle: statusRequestService)
        
        HouseDevice.current().messageOutbox.add(message: message, expiresAt: Date().addingTimeInterval(5))
        
    }
    
    public func didDetermineLightStatus(was status: LightStatus, at time: Date = Date()) {
        Log.debug("Determined \(self.identifier) status is: \(status)", in: .category)
        
        let value = RecordedValue(status, recordedAt: time)
        self.recordValue(value, for: .lightStatus)
    }
    
}

//
//  AmbientSensorExtension.swift
//  House
//
//  Created by Shaun Merchant on 08/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

// MARK: - Light Control
extension HouseExtension: AmbientLightSensorDelegate {
    
    public func didRequestAmbientLightReading() {
        guard self.conforms(to: .ambientLightSensor) else {
            Log.debug("Attempted to get ambient sensor reading of \(self.identifier), however it is not an ambient light sensor.", in: .category)
            return
        }
        
        Log.debug("Extension \(self.identifier) requesting ambient light reading", in: .category)
        
        let statusRequestService = ServiceBundle(package: 112, service: 1)!
        let message = Message(to: self.identifier, bundle: statusRequestService)
        
        HouseDevice.current().messageOutbox.add(message: message, expiresAt: Date().addingTimeInterval(5))
        
    }
    
    public func didDetermineAmbientLightReading(was ambientLight: AmbientLight, at time: Date = Date()) {
        Log.debug("Determined \(self.identifier) ambient sensor reading is: \(ambientLight)", in: .category)
        
        let value = RecordedValue(ambientLight, recordedAt: time)
        self.recordValue(value, for: .ambientLightSensorReading)
    }
    
}

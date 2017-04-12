//
//  LightBrightnessExtension.swift
//  House
//
//  Created by Shaun Merchant on 17/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

// MARK: - Light Brightness
extension HouseExtension: LightBrightnessControllerDelegate {
    
    public func setLightBrightness(to lightBrightness: LightBrightness) {
        guard self.conforms(to: .lightBrightnessController) else {
            Log.debug("Attempted to dim \(self.identifier), however it is not a light.", in: .category)
            return
        }
        
        Log.debug("Extension \(self.identifier) is dimming to \(lightBrightness).", in: .category)
        
        let dimService = ServiceBundle(package: 111, service: 3, data: lightBrightness.archive())!
        let message = Message(to: self.identifier, bundle: dimService)
        
        HouseDevice.current().messageOutbox.add(message: message, expiresAt: Date().addingTimeInterval(5))
    }
    
    public func didRequestLightBrightness() {
        
    }
    
    public func didDetermineLightBrightness(was lightBrightness: LightBrightness, at time: Date = Date()) {
        let value = RecordedValue(lightBrightness, recordedAt: time)
        self.recordValue(value, for: .lightBrightness)
    }
    
}

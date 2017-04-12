//
//  SwitchExtension.swift
//  House
//
//  Created by Shaun Merchant on 15/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

// MARK: - Switch Control
extension HouseExtension: SwitchControllerDelegate {
    
    public func didRequestSwitchState() {
        guard self.conforms(to: .switchController) else {
            Log.debug("Attempted to get switch state of \(self.identifier), however it is not a switch.", in: .category)
            return
        }
        
        Log.debug("Extension \(self.identifier) requesting switch state", in: .category)
        
        let statusRequestService = ServiceBundle(package: 113, service: 1)!
        let message = Message(to: self.identifier, bundle: statusRequestService)
        
        HouseDevice.current().messageOutbox.add(message: message, expiresAt: Date().addingTimeInterval(5))
        
    }
    
    public func didDetermineSwitchState(was state: SwitchState, at time: Date = Date()) {
        Log.debug("Determined \(self.identifier) switch state is: \(state)", in: .category)
        
        let value = RecordedValue(state, recordedAt: time)
        self.recordValue(value, for: .switchState)
    }
    
}

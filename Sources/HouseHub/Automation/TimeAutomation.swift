//
//  TimeAutomationRule.swift
//  House
//
//  Created by Shaun Merchant on 03/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation

/// An automation that executes at points in time.
public protocol TimeAutomation: Automation {
    
    /// The time into the day when the rule next requires to perform.
    ///
    /// - Important: `nextDue` should not block for response as this will delay all rules from being executed promptly in each sweep.
    ///              `nextDue` should be available (near) instantly.
    ///
    /// - Example: Lights may wish to turn on automagically at Sunset. Sunset time could be pulled using a third-party API service.
    ///            A HTTP request for Sunset time could take several seconds, which if `nextDue` blocked return for whilst waiting,
    ///            which would delay all other rules in the sweep, and potentially subsequent sweeps.
    var nextDue: TimeInterval { get }
    
}

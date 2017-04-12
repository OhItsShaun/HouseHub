//
//  AutomationRule.swift
//  House
//
//  Created by Shaun Merchant on 02/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation

/// An automation.
public protocol Automation {
    
    /// The label of the automation.
    ///
    /// Labels are used to identify the rules in manual interfaces.
    ///
    /// - important: As rules are used in manual interfaces the label should be succint and easily typetable. 
    ///              For example "Switch on Bedroom Lights" can be shortened to "Light Bedroom".
    var label: String { get }
    
    /// Perform the automation.
    ///
    /// - important: This is performed asynchronously and concurrently with other rules.
    ///              Therefore lenthy tasks are "okay" and will not block other rules from occuring.
    ///              However, do not treat this liberally. Automation tasks should be **succinct**.
    func perform()
}

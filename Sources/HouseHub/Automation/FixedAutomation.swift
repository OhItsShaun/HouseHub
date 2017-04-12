//
//  FixedAutomationRule.swift
//  House
//
//  Created by Shaun Merchant on 15/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation

/// An automation that requires an external entity to request performance.
public struct FixedAutomation: Automation {
    
    public let label: String
    
    /// The closure to execute when requested to perform.
    private let actionBlock: () -> ()
    
    /// Instance a new FixedAutomationRule.
    ///
    /// - Parameters:
    ///   - label: The name of the rule.
    ///   - actionBlock: The closure to perform when the rule is requested to perform.
    init(_ label: String, perform actionBlock: @escaping () -> ()) {
        self.label = label
        self.actionBlock = actionBlock
    }
    
    public func perform() {
        self.actionBlock()
    }
    
}

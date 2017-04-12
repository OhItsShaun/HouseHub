//
//  WeeklyAutomationRule.swift
//  House
//
//  Created by Shaun Merchant on 07/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore
import Time

/// An automation executes at specific times on days of the week.
public struct DailyAutomation: TimeAutomation {
    
    public let label: String
    
    /// The time to execute.
    public var nextDue: TimeInterval {
        get {
            if self.performsOnDays.contains(Weekday.today) {
                return self.time.timeIntervalIntoCurrentDay
            }
            else {
                return Date.distantFuture.timeIntervalSince1970
            }
        }
    }
    
    /// Time on days
    private let time: TimeRepresentable
    
    /// The days on which the automation should perform.
    private let performsOnDays: Set<Weekday>
    
    /// The automation to execute.
    private let actionBlock: () -> ()
    
    /// Instance a new daily automation rule.
    ///
    /// - Parameters:
    ///   - label: The name of the rule.
    ///   - time: The time at which the automation should perform.
    ///   - onDays: The days of the week the rule should perform.  
    ///   - actionBlock: The closure to perform when the rule is requested to perform.
    init(_ label: String, at time: TimeRepresentable, only onDays: Set<Weekday> = Set<Weekday>(Weekday.all()), perform actionBlock: @escaping () -> ()) {
        self.label = label
        self.time = time
        self.performsOnDays = onDays
        self.actionBlock = actionBlock
    }
    
    public func perform() {
        self.actionBlock()
    }
    
}

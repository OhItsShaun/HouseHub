//
//  Automation.swift
//  House
//
//  Created by Shaun Merchant on 02/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore
#if os(Linux)
    import Dispatch
#endif

/// A structure to store and execute Automation automations.
public struct AutomationCollection {
    
    /// automations in automation.
    fileprivate var automations: [Automation] = []
    
    /// The concurrent queue used to handle asynchronous automation.
    fileprivate let concurrentQueue = DispatchQueue(label: "house.automation", qos: .utility, attributes: .concurrent)
    
    /// The last time automations were checked to perform.
    fileprivate var lastSweep: TimeInterval = 0
    
    /// Create a new automation collection.
    /// Automations are fired at the start of every minute automatically.
    public init() {
        guard #available(OSX 10.12, *) else {
            fatalError("Unsupported version of OSX. Please compile for OSX 10.12.")
        }
        let timer = Timer(fire: Date.roundedToMinute(), interval: 60, repeats: true) { _ in
            House.automation.performTimeDueAutomations()
        }
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
}

// MARK: - AutomationCollection automations
public extension AutomationCollection {
    
    /// Execute automations that are due to be performed.
    public mutating func performTimeDueAutomations() {
        
        let currentSweep = Date.timeIntervalIntoCurrentDay
        
        Log.debug("Sweeping \(automations.count) automations at \(currentSweep)", in: .automation)
        
        // If the current sweep is **before** the previous sweep it can only mean we've gone into a new day.
        // Therefore, we reset the last sweep to be the start of a new day: 0.
        //
        // - Example:
        // ```
        // let lastSweep = TimeInterval(82800) // 23.00
        // let currentSweep = TimeInterval(60) // 00.01
        // ```
        if currentSweep < self.lastSweep {
            self.lastSweep = 0
        }
        
        for rule in self {
            if let timedRule = rule as? TimeAutomation {
                // Guard that the rule is due
                guard timedRule.nextDue > self.lastSweep && timedRule.nextDue <= currentSweep else {
                    continue
                }
        
                // Perform it asynchronously
                self.concurrentQueue.async {
                    Log.debug("Performing Due Automation (\(rule.label))", in: .automation)
                    rule.perform()
                }
            }
        }
        
        self.lastSweep = currentSweep
    }
    
    /// Perform the automation with a given label.
    ///
    /// - Parameter label: The label of the automation to perform.
    public func performAutomation(called label: String) {
        for rule in self {
            if rule.label == label {
                Log.debug("Performing Automation (\(rule.label))", in: .automation)
                rule.perform()
                return
            }
        }
    }
    
}

// MARK: - Updating automations
public extension AutomationCollection {
    
    /// Add an automation to the collection.
    ///
    /// - Parameter automation: The automation to add to the collection.
    mutating public func addAutomation(_ automation: Automation) {
        self.automations += [automation]
    }
    
    /// Remove all automations from the collection.
    mutating public func removeAll() {
        self.automations = []
    }
}

// MARK: - Sequence
extension AutomationCollection: Sequence {
    
    public func makeIterator() -> IndexingIterator<Array<Automation>> {
        return self.automations.makeIterator()
    }
    
}


//
//  HouseExtension.swift
//  House
//
//  Created by Shaun Merchant on 24/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// An Extension represents a device that the House Hub can commuincate with.
public class HouseExtension: Extension, DynamicCategoryController {
    
    public var identifier: HouseIdentifier
    
    public var label: String? = nil
    
    fileprivate var categories = Set<HouseCategory>()
    
    fileprivate var characteristics = CharacteristicStore()
    
    /// Create an instance of a House Extension.
    ///
    /// - Parameter identifier: The House Identifier of the House Extension.
    public init(_ identifier: HouseIdentifier) {
        self.identifier = identifier
    }
    
    public func conforms(to category: HouseCategory) -> Bool {
        return self.categories.contains(category)
    }
    
    public func recordValue(_ value: RecordedValue, for characteristic: Characteristic) {
        self.characteristics.insertValue(value, for: characteristic)
        House.events.characteristicValueDidChange(in: self, for: characteristic)
    }
    
    public func latestValue(for characteristic: Characteristic) -> RecordedValue? {
        return self.characteristics.latestValue(for: characteristic)
    }
    
    public func history(for characteristic: Characteristic) -> Array<RecordedValue> {
        return self.characteristics.allValues(for: characteristic)
    }
    
    /// Enable support for a House Category.
    ///
    /// - Parameter category: The category to enable support for.
    public func enableSupport(for category: HouseCategory) {
        self.categories.insert(category)
    }
    
    /// Remove support for a House Category.
    ///
    /// - Parameter category: The category to remove support for.
    public func removeSupport(for category: HouseCategory) {
        self.categories.remove(category)
    }
}

extension HouseExtension: CustomStringConvertible {
    
    public var description: String {
        get {
            return "HouseExtension[identifier: \(self.identifier), categories: \(self.categories)]"
        }
    }
    
}

//
//  Extension.swift
//  House
//
//  Created by Shaun Merchant on 08/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// An Extension represents a device that the House Hub can commuincate with.
public protocol Extension: CustomStringConvertible {
    
    /// The unique identifier of the extension.
    var identifier: HouseIdentifier { get set }
    
    /// An informal label defined by the user to represent the extension.
    var label: String? { get set }
    
    var description: String { get }

    /// Record a value for a characteristic of the Extension.
    ///
    /// - Parameters:
    ///   - value: The value of the characterstic.
    ///   - characteristic: The characterstic the Extension has recorded a value of.
    func recordValue(_ value: RecordedValue, for characteristic: Characteristic)
    
    /// Retrieve the most recent value for a characterstic of the Extension.
    ///
    /// - Parameter characteristic: The characterstic to retrieve the most recent value recorded.
    /// - Returns: The most recent value recorded if one exists, nil otherwise.
    func latestValue(for characteristic: Characteristic) -> RecordedValue?
    
    /// Retrieve the history of known values for a characteristic. The history returned may not be exhaustive or complete, rather
    /// the contents will depend upon appropriateness.
    ///
    /// - Example: The brightness of a light would only need a history of one value, the most recent one, whereas it may be 
    ///            useful to keep several weeks history of temperature sensor readings.
    ///
    /// - Note: It is for implementors to decide how long to record characteristic values for.
    ///              Use common sense.
    ///
    /// - Important: Implementors should ensure recoverability of data where appropriate, such that in the event houseHub were
    ///              to restart relevant history is recovered.
    ///
    /// - Parameter characteristic: The characteristic to retrieve all known values.
    /// - Returns: All known values for a characteristic, and the time at which the value was recorded.
    func history(for characteristic: Characteristic) -> Array<RecordedValue>
    
}

public extension Extension {
    
    /// A type with a customised textual representation.
    public var description: String {
        get {
            return String(self.identifier)
        }
    }
    
}

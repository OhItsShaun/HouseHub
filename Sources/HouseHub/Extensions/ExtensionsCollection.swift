//
//  ExtensionsCollection.swift
//  House
//
//  Created by Shaun Merchant on 24/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// A collection of House Extensions.
public protocol ExtensionsCollection: Sequence {
    
    /// The amount of House Extensions in the collection.
    var count: Int { get }
    
    /// Add a House Extension to the collection.
    ///
    /// - Parameter member: The House Extenion to add to the collection.
    mutating func addExtension(_ member: Extension)
    
    /// Remove a House Extension from the collection.
    ///
    /// - Parameter houseIdentifier: The House Identifier of the House Extension to remove.
    mutating func removeExtension(withIdentifier houseIdentifier: HouseIdentifier)
    
    /// Remove all extensions.
    mutating func removeAll()

}

extension ExtensionsCollection where Self.Iterator.Element == Extension {

    /// Find and return a House Extension in the collection that has the given House Identifier.
    ///
    /// - Parameter houseIdentifier: The House Identifier of the House Extension to find.
    /// - Returns: The House Extension that has the given House Identifier, otherwise `nil` if the House Extension could not be found.
    public func findExtension(with houseIdentifier: HouseIdentifier) -> Extension? {
        let matchingDevices = self.filter { device -> Bool in
            return device.identifier == houseIdentifier
        }
    
        return matchingDevices.first
    }
    
    /// Determine if a collection has a given House Extension.
    ///
    /// - Parameter device: The House Extension to determine if it is contained within the collection.
    /// - Returns: Whether the collection contains the House Extension.
    public func contains(_ device: Extension) -> Bool {
        for collectionDevice in self {
            if device.identifier == collectionDevice.identifier {
                return true
            }
        }
        return false
    }

    
    /// Retrieve a collection of House Extensions that are all light controllers.
    ///
    /// - Returns: A collection of House Extensions that are all light controllers.
    public func lightControllers() -> ContiguousArray<LightControllerDelegate> {
        var devices = ContiguousArray<LightControllerDelegate>()
        devices.reserveCapacity(self.count)
        
        for device in self {
            if let device = device as? LightControllerDelegate {
                if let dynamicDevice = device as? DynamicCategoryController {
                    if dynamicDevice.conforms(to: .lightController) {
                        devices.append(device)
                    }
                }
                else {
                    devices.append(device)
                }
            }
        }
        
        return devices
    }
    
    /// Retrieve a collection of House Extensions that are all light brightness controllers.
    ///
    /// - Returns: A collection of House Extensions that are all light brightness controllers.
    public func lightBrightnessControllers() -> ContiguousArray<LightBrightnessControllerDelegate> {
        var devices = ContiguousArray<LightBrightnessControllerDelegate>()
        devices.reserveCapacity(self.count)
        
        for device in self {
            if let device = device as? LightBrightnessControllerDelegate {
                if let dynamicDevice = device as? DynamicCategoryController {
                    if dynamicDevice.conforms(to: .lightBrightnessController) {
                        devices.append(device)
                    }
                }
                else {
                    devices.append(device)
                }
            }
        }
        
        return devices
    }
    
    
    /// Retrieve a collection of House Extensions that are all light temprature controllers.
    ///
    /// - Returns: A collection of House Extensions that are all light temperature controllers.
    public func lightTemperatureControllers() -> ContiguousArray<LightTemperatureControllerDelegate> {
        var devices = ContiguousArray<LightTemperatureControllerDelegate>()
        devices.reserveCapacity(self.count)
        
        for device in self {
            if let device = device as? LightTemperatureControllerDelegate {
                if let dynamicDevice = device as? DynamicCategoryController {
                    if dynamicDevice.conforms(to: .lightTemperatureController) {
                        devices.append(device)
                    }
                }
                else {
                    devices.append(device)
                }
            }
        }
        
        return devices
    }
    
    
    /// Retrieve a collection of House Extensions that are all ambient light sensors.
    ///
    /// - Returns: A collection of House Extensions that are all ambient lights sensors.
    public func ambientLightSensors() -> ContiguousArray<AmbientLightSensorDelegate> {
        var devices = ContiguousArray<AmbientLightSensorDelegate>()
        devices.reserveCapacity(3)
        
        for device in self {
            if let device = device as? AmbientLightSensorDelegate {
                if let dynamicDevice = device as? DynamicCategoryController {
                    if dynamicDevice.conforms(to: .ambientLightSensor) {
                        devices.append(device)
                    }
                }
                else {
                    devices.append(device)
                }
            }
        }
        
        return devices
    }
    
    /// Retrieve a collection of House Extensions that are all switches.
    ///
    /// - Returns: A collection of House Extensions that are all switches.
    public func switches() -> ContiguousArray<SwitchControllerDelegate> {
        var devices = ContiguousArray<SwitchControllerDelegate>()
        devices.reserveCapacity(10)
        
        for device in self {
            if let device = device as? SwitchControllerDelegate {
                if let dynamicDevice = device as? DynamicCategoryController {
                    if dynamicDevice.conforms(to: .switchController) {
                        devices.append(device)
                    }
                }
                else {
                    devices.append(device)
                }
            }
        }
        
        return devices
    }
    
    /// Retrieve a collection of House Extensions that are Hub Interfaces.
    ///
    /// - Returns: A collection of House Extensions that are all Hub Interfaces.
    public func hubInterfaces() -> ContiguousArray<HubInterfaceDelegate> {
        var devices = ContiguousArray<HubInterfaceDelegate>()
        devices.reserveCapacity(5)
        
        for device in self {
            if let device = device as? HubInterfaceDelegate {
                if let dynamicDevice = device as? DynamicCategoryController {
                    if dynamicDevice.conforms(to: .hubInterface) {
                        devices.append(device)
                    }
                }
                else {
                    devices.append(device)
                }
            }
        }
        
        return devices
    }
}

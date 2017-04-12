//
//  HueTemperatureLight.swift
//  House
//
//  Created by Shaun Merchant on 04/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore 

/// A class that enables Hue lights to act as a House Extension and join the House Network.
public class HueTemperatureLight: Extension, LightTemperatureControllerDelegate, LightBrightnessControllerDelegate, LightControllerDelegate {

    public var identifier: HouseIdentifier
    
    public var label: String? = nil
    
    private let apiAddress: String
    
    private let lightID: String
    
    private var characteristics = CharacteristicStore()
    
    /// Create an instance of a Hue Light.
    ///
    /// - Parameters:
    ///   - apiAddress: The URL of the Hue Bridge API.
    ///   - lightIdentifier: The Hue identifier of the light.
    ///   - uniqueIdentifier: The unique device identifier of light.
    public init(apiAddress: String, lightIdentifier: String, uniqueIdentifier: String) {
        if apiAddress.hasSuffix("/") {
            self.apiAddress = apiAddress
        }
        else {
            self.apiAddress = apiAddress + "/"
        }
        self.label = uniqueIdentifier
        self.lightID = lightIdentifier
        
        let hash = abs(uniqueIdentifier.hashValue)
        self.identifier = HouseIdentifier(hash)
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
    
    //MARK: Light On/Off
    
    public func turnOnLight() {
        if self.postToHueLight(["on": true]) {
            self.didDetermineLightStatus(was: .on)
        }
    }
    
    public func turnOffLight() {
        if self.postToHueLight(["on": false]) {
            self.didDetermineLightStatus(was: .off)
        }
        
    }
    
    public func didRequestLightStatus() {
        
    }
    
    public func didDetermineLightStatus(was status: LightStatus, at time: Date = Date()) {
        let value = RecordedValue(status, recordedAt: time)
        self.recordValue(value, for: .lightStatus)
    }
    
    //MARK: Light Temperature 
    
    public func setLightTemperature(to lightTemperature: LightTemperature) {
        Log.debug("Setting mire..")
        let capTop = min(500, lightTemperature) // Hue supports highest 500 mire...
        let capBottom = max(153, capTop)        // ...and lowest 153 mire
        
        if self.postToHueLight(["ct": capBottom]) {
            self.didDetermineLightTemperature(was: capBottom)
        }
    }
    
    public func didRequestLightTemperature() {
        // perform code
    }
    
    public func didDetermineLightTemperature(was lightTemperature: LightTemperature, at time: Date = Date()) {
        let value = RecordedValue(lightTemperature, recordedAt: time)
        self.recordValue(value, for: .lightTemperature)
    }
    
    //MARK: Light Brightness
    
    public func setLightBrightness(to lightBrightness: LightBrightness) {
        Log.debug("Setting brightness.. \(lightBrightness)")
        let scaled = lightBrightness * 254.0
        if self.postToHueLight(["bri":Int(scaled)]) {
            self.didDetermineLightBrightness(was: lightBrightness)
        }
    }
    
    public func didRequestLightBrightness() {
        
    }
    
    public func didDetermineLightBrightness(was lightBrightness: LightBrightness, at time: Date = Date()) {
        let value = RecordedValue(lightBrightness, recordedAt: time)
        self.recordValue(value, for: .lightBrightness)
    }
    
    //MARK: Helpers
    
    /// Post a JSON object to the light of the Hue Bridge.
    ///
    /// - Parameter object: The JSON ojbect to post.
    /// - Returns: Whether the post was successful or not.
    private func postToHueLight(_ object: Any) -> Bool {
        guard let url = URL(string: self.apiAddress + "lights/" + self.lightID + "/state") else {
            return false
        }
        
        guard let _ = JSONRequest.put(at: url, object) else {
            Log.warning("Couldn't post to Hue light \(self.identifier)", in: .hueDevice)
            return false
        }
        
        return true
    }
    
}

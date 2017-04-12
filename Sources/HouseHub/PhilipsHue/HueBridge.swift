//
//  HueBridge.swift
//  House
//
//  Created by Shaun Merchant on 21/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// A structure to communicate with a Hue Bridge.
public struct HueBridge {
    
    /// The IP address of the Hue Bridge.
    private var address: String
    
    /// The authorised username to use when making API calls to the Hue Bridge.
    private var username: String?

    /// Create an instance of a Hue Bridge.
    ///
    /// - Parameters:
    ///   - address: The address of the Hue Bridge.
    ///   - username: The authorised username of the Hue Bridge, if one exists already.
    public init(atAddress address: String, usingUsername username: String? = nil) {
        if address.hasSuffix("/") {
            self.address = address + "api/"
        }
        else {
            self.address = address + "/api/"
        }
        self.username = username
    }
    
    /// Check whether a username is authorised with the Hue Bridge.
    ///
    /// - Parameter username: The username to check for authorisation.
    /// - Returns: Whether the username is authorised or not, or false if there is no response from the Hue Bridge.
    internal func usernameAuthorised(_ username: String) -> Bool {
        guard let url = URL(string: self.address + username) else {
            Log.fatal("Badly formatted url: \(self.address + username)", in: .hueNetwork)
            return false
        }
        
        guard let response = JSONRequest.get(from: url) else {
            return false
        }
        
        let jsonObject: Any
        do {
            jsonObject = try JSONSerialization.jsonObject(with: response)
        }
        catch {
            Log.fatal("Hue JSON error: \(response)", in: .hueNetwork)
            return false
        }
        
        if jsonObject is [AnyHashable: AnyHashable] {
            return true
        }
        
        if let jsonArray = jsonObject as? [Any] {
            guard jsonArray.count > 0 else {
                return false
            }
            
            if let jsonDictionary = jsonArray[0] as? [AnyHashable: AnyHashable] {
                let error = jsonDictionary.contains { (key, _) in
                    if let key = key as? String, key == "error" {
                        return true
                    }
                    return false
                }
                return !error
            }
        }
        return false
    }
    
    /// Attempt to connect to the Hue Bridge and store the username for future API calls 
    /// if connection is successful.
    ///
    /// - Parameter username: The username to attempt to connect to the Hue Bridge with.
    /// - Returns: Whether connection was successful or not.
    mutating public func connect(as username: String) -> Bool {
        guard self.usernameAuthorised(username) else {
            return false
        }
        
        self.username = username
        return true
    }
    
    /// Retrieve all lights from the Hue Bridge.
    ///
    /// - Returns: All lights that are connected to the Hue Bridge as controllable House Extensions.
    public func getLights() -> [Extension] {
        guard let username = self.username else {
            Log.debug("Username doesnt exist to fetch extensions.", in: .hueNetwork)
            return []
        }
        guard let url = URL(string: self.address + username + "/lights") else {
            Log.fatal("Badly formatted url: \(self.address + username)", in: .hueNetwork)
            return []
        }
        guard let response = JSONRequest.get(from: url) else {
            return []
        }
        
        let jsonDictionary: [AnyHashable: Any]
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: response) as? [AnyHashable: Any] {
                jsonDictionary = jsonArray
            }
            else {
                throw JSONError("Not [AnyHashable:Any]")
            }
        }
        catch {
            Log.fatal("Badly formatted JSON \(response)", in: .hueNetwork)
            return []
        }
        
        var hueLights = [Extension]()
        
        for (key, value) in jsonDictionary {
            guard let lightID = key as? String else {
                continue
            }
            guard let value = value as? [AnyHashable: Any] else {
                continue
            }
            guard let uniqueID = value["uniqueid"] as? String else {
                continue
            }
            
            if let model = value["type"] as? String {
                if model == "Color temperature light" {
                    let hueLight = HueTemperatureLight(apiAddress: self.address + username, lightIdentifier: lightID, uniqueIdentifier: uniqueID)
                    hueLights.append(hueLight)
                }
            }
        }
        
        return hueLights
    }
}


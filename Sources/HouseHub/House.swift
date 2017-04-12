//
//  House.swift
//  House
//
//  Created by Shaun Merchant on 17/01/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation

/// The `House` structure acts as a singleton representing the user's physical home and events that can occur within their home.
/// Through the singleton interactions with houseExtensions and rooms can occur, and automations and events can be triggered or 
/// set.
///
/// - Important: `House` is currently available only to houseHub.
public struct House {
    
    /// The rooms inside the home.
    public static var rooms = Rooms()
    
    /// The extensions registered to the houseHub.
    public static var extensions = Extensions()
    
    /// The automations set inside the houseHub.
    public static var automation = AutomationCollection()
    
    /// The event handler for the houseHub.
    public static var events = Events()
    
}

//
//  Rooms.swift
//  House
//
//  Created by Shaun Merchant on 02/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation

/// A structure to represent Rooms in House.
///
/// - Important: Modifications **should not** be made by any devices other than the houseHub or interfaces to the hub.
///              houseExtensions should be passive recievers of updates **not** modifiers.
///              In other words, houseExtensions should treat `Rooms` and its values as read-only.
///
public struct Rooms {
    
    fileprivate var rooms = [String: Room]()
    
    fileprivate var lock = DispatchQueue(label: "RoomLock", qos: .utility)
    
    fileprivate var notification = DispatchQueue(label: "Notification", qos: .utility, attributes: .concurrent)
}

extension Rooms {
    
    /// Find the room that contains a give House Extension.
    ///
    /// - Parameter device: The House Extension to find.
    /// - Returns: The room that contains the House Extension, otherwise `nil` if no room contains the House Extension.
    public func findRoom(with device: Extension) -> Room? {
        for (_, room) in self.rooms {
            if room.extensions.contains(device) {
                return room
            }
        }
        
        return nil 
    }
    
    /// Retrieve the room with a given name.
    ///
    /// - Parameter name: The name of the room to find.
    /// - Returns: The room with the given nil, otherwise `nil` if no room with the given name can be found.
    func findRoom(called name: String) -> Room? {
        return self.rooms[name]
    }
    
}

extension Rooms {
    
    /// Add a room.
    ///
    /// - Important: If a room exists with the same name that room will be overwriting with the argument.
    ///
    /// - Parameter newRoom: The room to add.
    mutating func addRoom(_ newRoom: Room) {
        self.lock.sync {
            self.rooms[newRoom.name] = newRoom
        }
        
        self.notification.async {
            for interface in House.extensions.hubInterfaces() {
                interface.room(called: newRoom.name, was: .updated)
            }
        }
    }
    
}

extension Rooms {
    
    /// Remove all rooms.
    mutating func removeAll() {
        for (name, _) in self.rooms {
            self.removeRoom(called: name)
        }
    }
    
    /// Delete a Room by its name.
    ///
    /// - Parameter roomValue: The Room to delete by value.
    mutating func removeRoom(called name: String) {
        self.lock.sync {
            _ = self.rooms.removeValue(forKey: name)
        }
        
        self.notification.async {
            for interface in House.extensions.hubInterfaces() {
                interface.room(called: name, was: .removed)
            }
        }
    }
    
}

extension Rooms: Sequence {
    
    public func makeIterator() -> IndexingIterator<[Room]> {
        var rooms = [Room]()
        rooms.reserveCapacity(self.rooms.count)
        
        for (_, room) in self.rooms {
            rooms += [room]
        }
        
        return rooms.makeIterator()
    }
    
}

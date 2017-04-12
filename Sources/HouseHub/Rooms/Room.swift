//
//  Room.swift
//  House
//
//  Created by Shaun Merchant on 24/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore
import Archivable

/**
 # Overview
 A structure to represent a physical room in a house. A room can contain multiple extensions which can assis
 
 
 */
public struct Room {
    
    /// The name of the room.
    ///
    /// - Important: The name of the room must be unique.
    public var name: String
    
    /// The extensions contained within the room.
    public var extensions = Room.Extensions()
    
    /// Create a new room with a given name.
    ///
    /// - Parameter name: The name of the room.
    public init(called name: String) {
        self.name = name
    }
    
    /// A room's representation of a House Extension's colletion.
    final public class Extensions: ExtensionsCollection {
        
        public var count: Int {
            get {
                return self.houseIdentifiers.count
            }
        }
        
        /// A collection of House Identifiers that the room "owns".
        fileprivate var houseIdentifiers = Set<HouseIdentifier>()
        
        /// Retrieve all House Extensions that the room contains, converting the set of House Identifiers to instances.
        ///
        /// - Returns: Instances of House Extensions the room contains.
        private func extensionsInCurrentRoom() -> [Extension] {
            var devices = [Extension]()
            for identifier in self.houseIdentifiers {
                if let device = House.extensions.findExtension(with: identifier) {
                    devices += [device]
                }
            }
            return devices
        }
        
        public func addExtension(_ member: Extension){
           self.houseIdentifiers.insert(member.identifier)
        }
        
        public func removeExtension(withIdentifier houseIdentifier: HouseIdentifier) {
            self.houseIdentifiers.remove(houseIdentifier)
        }
        
        public func makeIterator() -> IndexingIterator<[Extension]> {
            let devices = self.extensionsInCurrentRoom()
            return devices.makeIterator()
        }
        
        public func removeAll() {
            self.houseIdentifiers.removeAll()
        }
    }
    
}

extension Room.Extensions: Archivable {
    
    public func archive() -> Data {
        var data = Data()
        data.append(self.houseIdentifiers.count.archive())
        
        for identifier in self.houseIdentifiers {
            data.append(identifier.archive())
        }
        
        return data
    }
    
}

extension Room: Archivable {
    
    public func archive() -> Data {
        var data = Data()
        
        let name = self.name.archive()
        data.append(name.count.archive())
        data.append(name)
        
        let extensions = self.extensions.archive()
        data.append(extensions)
        
        return data
    }
    
}
extension Room: Unarchivable {
    
    public static func unarchive(_ data: Data) -> Room? {
        var data = data
        
        // Retrieve the name.
        guard let nameCountData = data.remove(forType: Int.self) else {
            return nil
        }
        guard let nameCount = Int.unarchive(nameCountData) else {
            return nil
        }
        guard let nameData = data.remove(to: nameCount) else {
            return nil
        }
        guard let name = String.unarchive(nameData) else {
            return nil
        }
        let room = Room(called: name)
        
        // Retrieve the extensions.
        guard let extensionsCountData = data.remove(forType: Int.self) else {
            return nil
        }
        guard let extensionsCount = Int.unarchive(extensionsCountData) else {
            return nil
        }
        
        var extensions = Set<HouseIdentifier>(minimumCapacity: extensionsCount)
        for _ in 0..<extensionsCount {
            guard let extensionIdentifierData = data.remove(forType: HouseIdentifier.self) else {
                Log.warning("Room corruption: Lack of data fulfillment.", in: .houseStructs)
                return room
            }
            guard let extensionIdentifier = HouseIdentifier.unarchive(extensionIdentifierData) else {
                Log.warning("Room corruption: Could not unarchive House Identifier.", in: .houseStructs)
                continue
            }
            extensions.insert(extensionIdentifier)
        }
        room.extensions.houseIdentifiers = extensions
        
        return room
    }
}

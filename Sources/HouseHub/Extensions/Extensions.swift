//
//  Extensions.swift
//  House
//
//  Created by Shaun Merchant on 24/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// A standard conformance to `ExtensionsCollection`.
public struct Extensions: ExtensionsCollection {
    
    public var count: Int {
        get {
            return self.extensions.count
        }
    }
    
    fileprivate var extensions = [Extension]()
    
    fileprivate var lock = DispatchQueue(label: "RoomLock", qos: .utility)
    
    fileprivate var notification = DispatchQueue(label: "Notification", qos: .utility, attributes: .concurrent)
  
}

extension Extensions: Sequence {
    
    public func makeIterator() -> IndexingIterator<[Extension]> {
        return self.extensions.makeIterator()
    }
    
}

extension Extensions {
    
    public mutating func addExtension(_ member: Extension) {
        self.lock.sync {
            let containsDevice = self.extensions.contains { device -> Bool in
                return device.identifier == member.identifier
            }
            
            guard !containsDevice else {
                return
            }
            
            self.extensions += [member]
        }
        self.notification.async {
            for interface in House.extensions.hubInterfaces() {
                interface.houseExtension(with: member.identifier, was: .updated)
            }
        }
    }
    
}

extension Extensions {
  
    public mutating func removeAll() {
        for device in self {
            self.removeExtension(withIdentifier: device.identifier)
        }
    }
    
    public mutating func removeExtension(withIdentifier houseIdentifier: HouseIdentifier) {
        self.lock.sync {
            self.extensions = self.extensions.filter { houseExtension -> Bool in
                return houseExtension.identifier != houseIdentifier
            }
        }
        
        self.notification.async {
            for interface in House.extensions.hubInterfaces() {
                interface.houseExtension(with: houseIdentifier, was: .removed)
            }
        }
    }
    
}

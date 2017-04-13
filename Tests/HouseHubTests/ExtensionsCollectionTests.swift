//
//  ExtensionsCollectionTests.swift
//  House
//
//  Created by Shaun Merchant on 25/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import XCTest
import HouseCore 
@testable import HouseHub

class ExtensionsCollectionTests: XCTestCase {

    var extensions: Extensions! = nil
    
    override func setUp() {
        super.setUp()
        self.extensions = Extensions()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAddExtension() {
        self.extensions.addExtension(newExtension(1))
        if let _ = self.extensions.findExtension(with: 1) {
            return
        }
        XCTFail("Did not find extension.")
    }

    func testIterator() {
        self.extensions.addExtension(newExtension(1))
        self.extensions.addExtension(newExtension(2))
        self.extensions.addExtension(newExtension(3))
        
        var foundIDs = Set<HouseIdentifier>()
        for device in self.extensions {
            foundIDs.insert(device.identifier)
        }
        
        if foundIDs.count == 3 && foundIDs.contains(1) && foundIDs.contains(2) && foundIDs.contains(3) {
            return
        }
        
        XCTFail("Iterator did not produce all extensions.")
        
    }

    func testAddMultipleExtensions() {
        self.extensions.addExtension(newExtension(1))
        self.extensions.addExtension(newExtension(2))
        self.extensions.addExtension(newExtension(3))
        
        if self.extensions.findExtension(with: 1) == nil {
            XCTFail("Did not find extension 1.")
        }
        if self.extensions.findExtension(with: 2) == nil {
            XCTFail("Did not find extension 2.")
        }
        if self.extensions.findExtension(with: 3) == nil {
            XCTFail("Did not find extension 3.")
        }
        
    }
    
    func testAddSameExtension() {
        self.extensions.addExtension(newExtension(1))
        self.extensions.addExtension(newExtension(1))
        
        if self.extensions.findExtension(with: 1) == nil {
            XCTFail("Did not find extension 1.")
        }
        
        var foundIDs = [HouseIdentifier]()
        
        for device in self.extensions {
            foundIDs += [device.identifier]
        }
        
        if foundIDs.count != 1 {
            XCTFail("Expected ID count was not met. Recieved: \(foundIDs).")
        }
        
        if foundIDs[0] != 1 {
            XCTFail("ID recieved was not equal to 1. Recieved: \(foundIDs)")
        }
    }
    
    func testConformance() {
        let lightDevice = self.newExtension(1, conformsTo: [.lightController, .lightBrightnessController])
        let lightDevice2 = self.newExtension(3, conformsTo: [.lightController])
        let dumbDevice = self.newExtension(4)
        
        self.extensions.addExtension(lightDevice)
        self.extensions.addExtension(lightDevice2)
        self.extensions.addExtension(dumbDevice)
        
        let lightDevices = self.extensions.lightControllers()
        
        var extensionDevices = [Extension]()
        for lightDevice in lightDevices {
            if let lightDevice = lightDevice as? Extension {
                extensionDevices += [lightDevice]
            }
        }
        
        if extensionDevices.count != 2 {
            XCTFail("Expected 2 devices, recieved: \(lightDevices)")
        }
        
        if extensionDevices[0].identifier == lightDevice.identifier {
            if extensionDevices[1].identifier != lightDevice2.identifier {
                XCTFail("Did not recieve expected devices. Recieved: \(lightDevices)")
            }
        }
        else if extensionDevices[0].identifier == lightDevice2.identifier {
            if extensionDevices[1].identifier != lightDevice.identifier {
                XCTFail("Did not recieve expected devices. Recieved: \(lightDevices)")
            }
        }
        else {
            XCTFail("No expected devices recieved. Recieved: \(lightDevices)")
        }
        
    }
    
    func testFindExtentionDoesntExist() {
        self.extensions.addExtension(newExtension(1))
        self.extensions.addExtension(newExtension(2))
        self.extensions.addExtension(newExtension(3))
        
        if let device = self.extensions.findExtension(with: 5) {
            XCTFail("Found unexpected device: \(device).")
        }
    }
    
    func testFindExtensionDidExist() {
        self.extensions.addExtension(newExtension(1))
        self.extensions.addExtension(newExtension(2))
        self.extensions.addExtension(newExtension(3))
        
        if self.extensions.findExtension(with: 2) == nil {
            XCTFail("Finding failed.")
        }
        
        self.extensions.removeExtension(withIdentifier: 2)
        
        if let device = self.extensions.findExtension(with: 2) {
            XCTFail("Unexpected found device: \(device)")
        }

    }
    
    func testRemoveExtension() {
        self.extensions.addExtension(newExtension(2))
        self.extensions.removeExtension(withIdentifier: 2)
        
        if let device = self.extensions.findExtension(with: 2) {
            XCTFail("Unexpected found device: \(device)")
        }
    }
    
    func testRemoveExtensionUnaffective() {
        self.extensions.addExtension(newExtension(1))
        self.extensions.addExtension(newExtension(2))
        self.extensions.addExtension(newExtension(3))
        
        self.extensions.removeExtension(withIdentifier: 2)
        
        if self.extensions.findExtension(with: 1) == nil {
            XCTFail("Did not find device 1. Possible corruption.")
        }
        if self.extensions.findExtension(with: 3) == nil {
            XCTFail("Did not find device 3. Possible corruption.")
        }
        
        self.extensions.removeExtension(withIdentifier: 3)
        
        if self.extensions.findExtension(with: 1) == nil {
            XCTFail("Did not find device 1. Possible corruption.")
        }
        if self.extensions.findExtension(with: 3) != nil {
            XCTFail("Found device for 3. Possible corruption.")
        }
        
        self.extensions.removeExtension(withIdentifier: 1)
        
        if self.extensions.findExtension(with: 1) != nil {
            XCTFail("Found device for 1. Possible corruption.")
        }
        if self.extensions.findExtension(with: 2) != nil {
            XCTFail("Found device for 2. Possible corruption.")
        }
        if self.extensions.findExtension(with: 3) != nil {
            XCTFail("Found device for 3. Possible corruption.")
        }
    }

    func newExtension(_ identifier: HouseIdentifier) -> Extension {
        return HouseExtension(identifier)
    }
    
    func newExtension(_ identifier: HouseIdentifier, conformsTo categories: [HouseCategory]) -> Extension {
        let device = HouseExtension(identifier)
        for category in categories {
            device.enableSupport(for: category)
        }
        
        return device
    }

}

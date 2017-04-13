//
//  HouseExtensionTests.swift
//  House
//
//  Created by Shaun Merchant on 25/02/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import XCTest
import HouseCore
import Random 
@testable import HouseHub

class HouseExtensionTests: XCTestCase {

    var device: HouseExtension! = nil
    
    override func setUp() {
        super.setUp()
        self.device = HouseExtension(1)
    }

    func testAddConformance() {
        self.device.enableSupport(for: .lightController)
        
        XCTAssert(self.device.conforms(to: .lightController))
        
        self.device.enableSupport(for: .lightBrightnessController)
        
        XCTAssert(self.device.conforms(to: .lightBrightnessController))
    }
    
    func testRemoveConformance() {
        self.device.removeSupport(for: .lightController)
        XCTAssert(!self.device.conforms(to: .lightController))
        
        self.device.enableSupport(for: .lightController)
        XCTAssert(self.device.conforms(to: .lightController))
        
        self.device.enableSupport(for: .lightBrightnessController)
        XCTAssert(self.device.conforms(to: .lightBrightnessController))
        
        self.device.removeSupport(for: .lightBrightnessController)
        XCTAssert(!self.device.conforms(to: .lightBrightnessController))
    }
    
    func testConformanceReflexivity() {
        self.device.enableSupport(for: .lightController)
        XCTAssert(self.device.conforms(to: .lightController))
        
        self.device.removeSupport(for: .lightController)
        XCTAssert(!self.device.conforms(to: .lightController))
        
        self.device.enableSupport(for: .lightController)
        XCTAssert(self.device.conforms(to: .lightController))
    }
    
    func testRecordValue() {
        let brightness = RecordedValue(LightBrightness(1.0))
        
        self.device.recordValue(brightness, for: .lightBrightness) // hope it doesn't crash..
    }
    
    func testRecordValues() {
        for _ in 0..<100 {
            let random = Random.generate()
            let brightnessFloat = Float(random) / 10.0
            let brightness = RecordedValue(LightBrightness(brightnessFloat))
            self.device.recordValue(brightness, for: .lightBrightness) // hope it doesn't crash..
        }
    }
    
    func testLatestValue() {
        for _ in 0..<100 {
            let brightness = RecordedValue(LightBrightness(0.2))
            self.device.recordValue(brightness, for: .lightBrightness) // hope it doesn't crash..
        }
        
        let brightness = RecordedValue(LightBrightness(0.5))
        self.device.recordValue(brightness, for: .lightBrightness)
        
        if let value = self.device.latestValue(for: .lightBrightness) {
            if let brightness = value.value as? LightBrightness {
                if brightness != 0.5 {
                    XCTFail("Brightness was not 0.5, instead: \(brightness)")
                }
            }
            else {
                XCTFail("Characteristic was not of type light brightness")
            }
        }
        else {
            XCTFail("Did not retreive any value.")
        }
        
        let dimmest = RecordedValue(LightBrightness(0.1))
        self.device.recordValue(dimmest, for: .lightBrightness)
        
        if let value = self.device.latestValue(for: .lightBrightness) {
            if let brightness = value.value as? LightBrightness {
                if brightness == 0.1 {
                    return
                }
                else {
                    XCTFail("Brightness was not 0.1, instead: \(brightness)")
                }
            }
            else {
                XCTFail("Characteristic was not of type light brightness")
            }
        }
        else {
            XCTFail("Did not retreive any value.")
        }
    }
    
    func testLatestValueOutOfOrder() {
        for _ in 0..<100 {
            let brightness = RecordedValue(LightBrightness(0.2))
            self.device.recordValue(brightness, for: .lightBrightness) // hope it doesn't crash..
        }
        
        let brightness = RecordedValue(LightBrightness(0.5), recordedAt: Date().addingTimeInterval(100))
        self.device.recordValue(brightness, for: .lightBrightness)
        
        for _ in 0..<100 {
            let brightness = RecordedValue(LightBrightness(0.2))
            self.device.recordValue(brightness, for: .lightBrightness) // hope it doesn't crash..
        }
        
        if let value = self.device.latestValue(for: .lightBrightness) {
            if let brightness = value.value as? LightBrightness {
                if brightness == 0.5 {
                    return
                }
                else {
                    XCTFail("Brightness was not 0.5, instead: \(brightness)")
                }
            }
            else {
                XCTFail("Characteristic was not of type light brightness")
            }
        }
        else {
            XCTFail("Did not retreive any value.")
        }
    }
    
    // We just want to make sure it has some memory
    func testHistory() {
        let brightness = RecordedValue(LightBrightness(10.0))
        self.device.recordValue(brightness, for: .lightBrightness)
        
        let history = self.device.history(for: .lightBrightness)
        
        if history.count == 0 {
            XCTFail("History has no memory.")
        }
        
        for item in history {
            if let brightness = item.value as? LightBrightness {
                if brightness == 10.0 {
                    return
                }
            }
        }
        
        XCTFail("Did not record brightness in history.")
    }

}

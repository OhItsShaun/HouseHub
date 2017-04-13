//
//  EventAutomationTests.swift
//  House
//
//  Created by Shaun Merchant on 17/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import XCTest
import HouseCore
import Time
@testable import HouseHub

class AutomationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let device1 = HouseExtension(12)
        let device2 = HouseExtension(145)
        let device3 = HouseExtension(120)
        let device4 = HouseExtension(2004)
        
        let room1 = Room(called: "Living Room")
        let room2 = Room(called: "Bedroom")
        let room3 = Room(called: "Kitchen")
        
        room1.extensions.addExtension(device1)
        room1.extensions.addExtension(device2)
        room2.extensions.addExtension(device3)
        
        House.rooms.addRoom(room1)
        House.rooms.addRoom(room2)
        House.rooms.addRoom(room3)
        
        House.extensions.addExtension(device1)
        House.extensions.addExtension(device2)
        House.extensions.addExtension(device3)
        House.extensions.addExtension(device4)
        
        let switchEvent = EventAutomation("Event 2", when: .switchState, changesIn: .houseExtension(identifier: 13)) { device in
            XCTFail("Event triggered when not appropriate.")
        }
        let lightEvent = EventAutomation("Event 3", when: .lightStatus, changesIn: .houseExtension(identifier: 11)) { device in
            XCTFail("Event triggered when not appropriate.")
        }
        let roomAutomation = EventAutomation("Event 5", when: .lightTemperature, changesIn: "Living Room") { device in
            XCTFail("Event triggered when not appropriate.")
        }
        let fixedAutomation = FixedAutomation("Fixed 1") {
            XCTFail("Event triggered when not appropriate.")
        }
    
        House.automation.addAutomation(switchEvent)
        House.automation.addAutomation(lightEvent)
        House.automation.addAutomation(roomAutomation)
        House.automation.addAutomation(fixedAutomation)
    }
    
    override func tearDown() {
        House.automation.removeAll()
        House.extensions.removeAll()
        House.rooms.removeAll()
    }

    func testExtensionEventAutomation() {
        let extensionExpectation = XCTestExpectation(description: "Event Extension Expectation")
        
        let lightEvent = EventAutomation("Event 1", when: .lightStatus, changesIn: 13) { device in
            XCTAssert(device.identifier == 13)
            extensionExpectation.fulfill()
            
        }
        House.automation.addAutomation(lightEvent)
        
        House.events.characteristicValueDidChange(in: HouseExtension(13), for: .lightStatus)
        
        let result = XCTWaiter.wait(for: [extensionExpectation], timeout: 1)
        XCTAssert(result == .completed)
    }
    
    
    func testRoomEventAutomation() {
        let roomExpectation = XCTestExpectation(description: "Event Room Expectation")
        
        let roomAutomation = EventAutomation("Event 4", when: .lightBrightness, changesIn: "Living Room") { device in
            XCTAssert(device.identifier == 12)
            roomExpectation.fulfill()
        }
        let roomAutomation2 = EventAutomation("Event 6", when: .lightBrightness, changesIn: "Living Room2") { device in
            XCTFail("Event triggered when not appropriate.")
        }
        House.automation.addAutomation(roomAutomation)
        House.automation.addAutomation(roomAutomation2)
        
        House.events.characteristicValueDidChange(in: HouseExtension(12), for: .lightBrightness)
        
        let result = XCTWaiter.wait(for: [roomExpectation], timeout: 1)
        XCTAssert(result == .completed)
    }
    
    func testFixedAutomation() {
        let expectation = XCTestExpectation(description: "Event Room Expectation")
        
        let fixedAutomation = FixedAutomation("Fixed 2") {
            expectation.fulfill()
        }
        House.automation.addAutomation(fixedAutomation)
        
        House.automation.performAutomation(called: "Fixed 2")
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        XCTAssert(result == .completed)
    }
    
    func testDailyAutomation() {
        let expectation = XCTestExpectation(description: "Event Daily Expectation")
        
        let automation = DailyAutomation("Daily Automation", at: Time.current) {
            expectation.fulfill()
        }
        let automation2 = DailyAutomation("Daily Automation 2", at: Time.current + Time(hour: 0, minute: 1)) {
            XCTFail("Event triggered when not appropriate.")
        }
        House.automation.addAutomation(automation)
        House.automation.addAutomation(automation2)
        House.automation.performTimeDueAutomations()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 3)
        XCTAssert(result == .completed)
    }
    
    func testCallingAutomation() {
        let expectation = XCTestExpectation(description: "Event Room Expectation")
        
        let fixedAutomation = FixedAutomation("Fixed 3") {
            expectation.fulfill()
        }
        let lightEvent = EventAutomation("Event 1", when: .lightStatus, changesIn: .houseExtension(identifier: 13)) { device in
            House.automation.performAutomation(called: "Fixed 3")
            
        }
        House.automation.addAutomation(fixedAutomation)
        House.automation.addAutomation(lightEvent)
        
        
        House.events.characteristicValueDidChange(in: HouseExtension(13), for: .lightStatus)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        XCTAssert(result == .completed)
    }
    
    func testAnyExtensionEventAutomation() {
        let extensionExpectation = XCTestExpectation(description: "Event Extension Expectation")
        
        let lightEvent = EventAutomation("Event 1", when: .lightStatus, changesIn: .anyExtension) { device in
            XCTAssert(device.identifier == 13)
            extensionExpectation.fulfill()
            
        }
        House.automation.addAutomation(lightEvent)
        
        House.events.characteristicValueDidChange(in: HouseExtension(13), for: .lightStatus)
        
        let result = XCTWaiter.wait(for: [extensionExpectation], timeout: 1)
        XCTAssert(result == .completed)
    }
    

}

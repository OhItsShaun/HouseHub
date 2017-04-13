//
//  HouseNetworkExtension.swift
//  HouseHub
//
//  Created by Shaun Merchant on 12/04/2017.
//
//

import Foundation
import HouseCore

public extension HouseNetwork {
    
    /// Open the House Network and set up any necessary packages.
    public func open() {
        HouseHubServices.registerAll()
        HouseNetwork.current().start()
        HouseNetwork.current().responseDelegate = HandshakeHandler()
    }
    
}

public extension HouseRuntime {
    
    /// Run the process as a House Hub.
    ///
    /// - Parameter process: The House Process to run.
    public static func run(process: HouseProcess) {
        HouseRuntime.run(process, as: .houseHub)
    }
    
}


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
    
    public func open() {
        HouseHubServices.registerAll()
        HouseNetwork.current().start()
        HouseNetwork.current().responseDelegate = HandshakeHandler()
    }
    
}

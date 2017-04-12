//
//  HandshakeHandler.swift
//  HouseHub
//
//  Created by Shaun Merchant on 12/04/2017.
//
//

import Foundation
import HouseCore

internal struct HandshakeHandler: HandshakeSuccessResponseDelegate {
    
    func handshakeDidSucceed(with response: HandshakeResponse) {
        guard let houseIdentifier = response.houseIdentifier else {
            return
        }
        
        let device = HouseExtension(houseIdentifier)
        if let categories = response.supportedCategories {
            for category in categories {
                device.enableSupport(for: category)
            }
        }
        Log.debug("Adding House Extension: \(device)", in: .network)
        House.extensions.addExtension(device)
        
    }
    
}

//
//  HubServices.swift
//  HouseHub
//
//  Created by Shaun Merchant on 12/04/2017.
//
//

import Foundation
import HouseCore

struct HouseHubServices {
    
    static func registerAll() {
        let packageRegistry = HouseDevice.current().packages
        
        packageRegistry.register(in: 111, service: 4) { data in
            var data = data
            Log.debug("Recieved Light Status...", in: .standardPackages)
            
            if HouseDevice.current().role == .houseHub {
                guard let senderIdentifierData = data.remove(forType: HouseIdentifier.self) else {
                    Log.debug("> Malformed data in Light Status. Did not receive identifier data.", in: .standardPackages)
                    return
                    
                }
                guard let senderIdentifier = HouseIdentifier.unarchive(senderIdentifierData) else {
                    Log.debug("> Malformed data in Light Status. Could not unarchive identifier.", in: .standardPackages)
                    return
                    
                }
                guard let sender = House.extensions.findExtension(with: senderIdentifier) else {
                    Log.debug("> Recieved status about extension that does not exist: \(senderIdentifier)", in: .standardPackages)
                    return
                }

                guard let light = sender as? LightControllerDelegate else {
                    Log.debug("> Recieved status about extension that is not light controller.", in: .standardPackages)
                    return
                }
                
                guard let status = LightStatus.unarchive(data) else {
                    Log.debug("> Light Status Enum Malformed", in: .standardPackages)
                    return
                    
                }
                light.didDetermineLightStatus(was: status)
            }
            else {
                Log.debug("> Recieved Light Status but I am not a hub.", in: .standardPackages)
            }
        }
        
        packageRegistry.register(in: 111, service: 13) { data in
            var data = data
            Log.debug("Recieved Light Brightness Status...", in: .standardPackages)
            
            if HouseDevice.current().role == .houseHub {
                guard let senderIdentifierData = data.remove(forType: HouseIdentifier.self) else {
                    Log.debug("> Malformed data in Light Brightness. Did not receive identifier data.", in: .standardPackages)
                    return
                    
                }
                guard let senderIdentifier = HouseIdentifier.unarchive(senderIdentifierData) else {
                    Log.debug("> Malformed data in Light Brightness. Could not unarchive identifier.", in: .standardPackages)
                    return
                    
                }
                guard let sender = House.extensions.findExtension(with: senderIdentifier) else {
                    Log.debug("> Recieved brightness about extension that does not exist: \(senderIdentifier)", in: .standardPackages)
                    return
                }
                guard let light = sender as? LightBrightnessControllerDelegate else {
                    Log.debug("> Recieved status about extension that is not light brightness controller.", in: .standardPackages)
                    return
                }
                guard let brightness = LightBrightness.unarchive(data) else {
                    Log.debug("> Light Brightness Enum Malformed", in: .standardPackages)
                    return

                }

                light.didDetermineLightBrightness(was: brightness)
            }
            else {
                Log.debug("> Recieved Light Brightness but I am not a hub.", in: .standardPackages)
            }
        }
        packageRegistry.register(in: 112, service: 2) { data in
            var data = data
            Log.debug("Recieved Ambient Light Sensor Reading...", in: .standardPackages)
            
            if HouseDevice.current().role == .houseHub {
                guard let senderIdentifierData = data.remove(forType: HouseIdentifier.self) else {
                    Log.debug("> Malformed data in Ambient Light Reading. Did not receive identifier data.", in: .standardPackages)
                    return
                    
                }
                guard let senderIdentifier = HouseIdentifier.unarchive(senderIdentifierData) else {
                    Log.debug("> Malformed data in Ambient Light Reading. Could not unarchive identifier.", in: .standardPackages)
                    return
                    
                }
                guard let sender = House.extensions.findExtension(with: senderIdentifier) else {
                    Log.debug("> Recieved ambient reading about extension that does not exist: \(senderIdentifier)", in: .standardPackages)
                    return
                }

                guard let sensor = sender as? AmbientLightSensorDelegate else {
                    Log.debug("> Recieved ambient reading about extension that is not ambient light reader.", in: .standardPackages)
                    return
                }

                guard let status = AmbientLight.unarchive(data) else {
                    Log.debug("> Ambient reading malformed", in: .standardPackages)
                    return

                }

                Log.debug("> Reading was: \(status), from: \(sender)", in: .standardPackages)
                sensor.didDetermineAmbientLightReading(was: status)
            }
            else {
                Log.debug("> Recieved Light Status but I am not a hub.", in: .standardPackages)
            }
        }
        
        packageRegistry.register(in: 113, service: 2) { data in
            var data = data
            Log.debug("Recieved Switch State...", in: .standardPackages)
            
            if HouseDevice.current().role == .houseHub {
                guard let senderIdentifierData = data.remove(forType: HouseIdentifier.self) else {
                    Log.debug("> Malformed data in Switch State. Did not receive identifier data.", in: .standardPackages)
                    return
                    
                }
                guard let senderIdentifier = HouseIdentifier.unarchive(senderIdentifierData) else {
                    Log.debug("> Malformed data in Switch State. Could not unarchive identifier.", in: .standardPackages)
                    return
                    
                }
                guard let sender = House.extensions.findExtension(with: senderIdentifier) else {
                    Log.debug("> Recieved switch state about extension that does not exist: \(senderIdentifier)", in: .standardPackages)
                    return
                }

                guard let sensor = sender as? SwitchControllerDelegate else {
                    Log.debug("> Recieved switch state about extension that is not a switch.", in: .standardPackages)
                    return
                }

                guard let state = SwitchState.unarchive(data) else {
                    Log.debug("> Switch state malformed", in: .standardPackages)
                    return

                }

                Log.debug("> Switch State was: \(state), from: \(sender)", in: .standardPackages)
                //                    sensor.didDetermineSwitchState(was: state)
            }
            else {
                Log.debug("> Recieved Light Status but I am not a hub.", in: .standardPackages)
            }
        }

    }
    
}

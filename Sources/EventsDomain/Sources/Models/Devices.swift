//
//  Devices.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

public struct Devices: Equatable, Sendable {
    var devices: [String]
    
    static func mock() -> Devices {
        Devices(devices: ["iPhone", "iPad", "MacBook"])
    }
}

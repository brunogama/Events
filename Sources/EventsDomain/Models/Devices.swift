//
//  Devices.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

@MainActor 
public struct Devices: Equatable, Sendable {
    public var devices: [String]

    public init(devices: [String]) {
        self.devices = devices
    }

    public static func mock() -> Devices {
        Devices(devices: ["iPhone", "iPad", "MacBook"])
    }
}

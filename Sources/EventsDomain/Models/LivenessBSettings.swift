//
//  LivenessBSettings.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

public struct LivenessBSettings: Equatable, Sendable, Codable, Hashable {
    public var settingA: String
    public var settingB: Int

    public static func mock() -> LivenessBSettings {
        LivenessBSettings(settingA: "A", settingB: 1)
    }
}

//
//  LivenessBSettings.swift
//  EventsPackage
//
//  Created by Bruno on 02/11/24.
//

import Foundation

public struct LivenessBSettings, Sendable {
    var settingA: String
    var settingB: Int

    static func mock() -> LivenessBSettings {
        LivenessBSettings(
            settingA: "A",
            settingB: 1
        )
    }
}

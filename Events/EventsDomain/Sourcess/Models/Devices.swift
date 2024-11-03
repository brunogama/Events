//
//  Devices.swift
//  EventsPackage
//
//  Created by Bruno on 02/11/24.
//

import Foundation

package struct Devices: Equatable, Sendable {
    var devices: [String]

    #if DEBUG
    static func mock() -> Devices {
        Devices(
            devices: [
                "iPhone",
                "iPad",
                "MacBook"
            ]
        )
    }
    #endif
}

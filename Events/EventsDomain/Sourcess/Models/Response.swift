//
//  Response.swift
//  EventsPackage
//
//  Created by Bruno on 02/11/24.
//

import Foundation

public struct Response: Codable, Sendable {
    var status: String
    var message: String
    var data: Data
    var code: Int
}

extension Response {
    #if DEBUG
    package static func mock() -> Response {
        Response(status: "OK", message: "Success", data: Data(), code: 200)
    }
    #endif
}

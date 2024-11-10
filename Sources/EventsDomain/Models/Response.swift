//
//  Response.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

import Foundation

public struct Response: Equatable, Sendable , Codable, Hashable {
    public var status: String
    public var message: String
    public var data: Data
    public var code: Int

    public init(status: String, message: String, data: Data, code: Int) {
        self.status = status
        self.message = message
        self.data = data
        self.code = code
    }

    public static func mock() -> Response {
        Response(status: "OK", message: "Success", data: Data(), code: 200)
    }
}

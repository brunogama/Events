//
//  Taskl+Extensions.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Int) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
    }
}

//
//  Task+Extensions.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func delayFor(seconds: Int) async {
        let nanoseconds = UInt64(abs(seconds)) * 1_000_000_000
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
    
    public static func delayFor(for interval: TimeInterval) async {
        let nanoseconds = UInt64(abs(interval) * 1_000_000_000)

        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}

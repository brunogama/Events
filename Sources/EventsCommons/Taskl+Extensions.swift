//
//  Taskl+Extensions.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    @MainActor public static func delayFor(seconds: Int) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
    }
}

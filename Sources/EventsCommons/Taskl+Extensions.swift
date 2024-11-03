//
//  Taskl+Extensions.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Foundation
#if os(iOS)
extension Task where Success == Never, Failure == Never {
    public static func delayFor(seconds: Int) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
    }
}
#else
public final class Task {
    public static func delayFor(seconds: Int) async {
        sleep(UInt32(seconds))
    }

#endif

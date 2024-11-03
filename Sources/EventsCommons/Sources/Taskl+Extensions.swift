//
//  Taskl+Extensions.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Foundation

#if os(iOS)
    extension Task where Success == Never, Failure == Never {
        public static func sleep(seconds: UInt64) async {
            try? await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
        }
    }
#endif

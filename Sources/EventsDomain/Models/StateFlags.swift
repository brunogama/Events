//
//  StateFlags.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 20/11/24.
//

public struct StateFlags: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let none = StateFlags(rawValue: 1 << 0)
    public static let intro = StateFlags(rawValue: 1 << 1)
    public static let onboarding = StateFlags(rawValue: 1 << 2)
    public static let done = StateFlags(rawValue: 1 << 3)
    public static let removeDevices = StateFlags(rawValue: 1 << 4)
    public static let liveness = StateFlags(rawValue: 1 << 5)
    public static let sms = StateFlags(rawValue: 1 << 6)
    public static let email = StateFlags(rawValue: 1 << 7)
}

//
//  RegisterState.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import Foundation

public enum RegisterState: RawRepresentable, Equatable, Hashable, ReflectableDescription, Identifiable, Sendable {
    public var id: String {
        UUID().uuidString + instanceDescription
    }

    case none
    case intro
    case onboarding
    case done(account: String, password: String, response: Response)
    case removeDevices(Devices)
    case liveness(LivenessImplementation)
    case sms
    case email

    public typealias RawValue = String

    public init?(rawValue: String) {
        fatalError()
    }

    public var rawValue: String {
        self.name
    }

    public var name: String {
        String(describing: self)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
    }

    public static func == (lhs: RegisterState, rhs: RegisterState) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(instanceDescription)
    }

    public static func mockDone() -> RegisterState {
        .done(
            account: "account",
            password: "password",
            response: .mock()
        )
    }

    public var stateFlag: StateFlags {
        switch self {
        case .none: return .none
        case .intro: return .intro
        case .onboarding: return .onboarding
        case .done: return .done
        case .removeDevices: return .removeDevices
        case .liveness: return .liveness
        case .sms: return .sms
        case .email: return .email
        }
    }

    public var deferredDependency: DeferredDependency {
        switch self {
        case .liveness: return .all([.sms, .email])
        default: return .none
        }
    }

}

extension RegisterState {
    public func toDestination() -> Destination {
        switch self {
        case .none: .none
        case .intro: .intro
        case .onboarding: .onboarding
        case .done: .done
        case .removeDevices: .removeDevices
        case .liveness: .liveness
        case .sms: .sms
        case .email: .email
        }
    }
}

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

public enum DeferredDependency {
    case all(StateFlags)
    case any(StateFlags)
    case either(StateFlags, StateFlags)
    case none
}

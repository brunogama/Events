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
        Mirror(reflecting: self).children.first?.label ?? String(describing: self)
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
        case .onboarding: return .all([.removeDevices, .liveness])
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


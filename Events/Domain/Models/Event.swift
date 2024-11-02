//
//  Event.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

// Models emulating the events sent by deviceregister

import Foundation

public enum Event: Hashable, Equatable, ReflectableDescription, Identifiable {
    public var id: Int {
        UUID().hashValue
    }
    
    case idle
    case startProcessing
    case loading
    case willUpdateState(RegisterState)
    case stateUpdated(RegisterState)
    case error(Error)
    
    public var name: String {
        String(describing: self)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
    }
    
    public static func == (lhrs: Event, rhs: Event) -> Bool {
        lhrs.instanceDescription == rhs.instanceDescription
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(instanceDescription)
    }
    
    var isProcessing: Bool {
        switch self {
        case .loading: return true
        case .startProcessing: return true
        case .willUpdateState: return true
        default: return false
        }
    }
}

extension Event {
    public var icon: String {
        switch self {
        case .idle:
            return "pause.circle"
        case .startProcessing:
            return "play.circle"
        case .loading:
            return "hourglass"
        case .willUpdateState:
            return "arrow.up.circle"
        case .stateUpdated:
            return "checkmark.circle"
        case .error:
            return "exclamationmark.triangle"
        }
    }
}

public struct Devices: Equatable {
    var devices: [String]

    static func mock() -> Devices {
        Devices(devices: ["iPhone", "iPad", "MacBook"])
    }
}

public struct Response: Codable {
    var status: String
    var message: String
    var data: Data
    var code: Int

    static func mock() -> Response {
        Response(status: "OK", message: "Success", data: Data(), code: 200)
    }
}

public struct LivenessBSettings {
    var settingA: String
    var settingB: Int

    static func mock() -> LivenessBSettings {
        LivenessBSettings(settingA: "A", settingB: 1)
    }
}

public enum LivenessImplementation {
    case implementationA
    case implementationB(LivenessBSettings)
}

public enum RegisterState: RawRepresentable, Equatable, Hashable, ReflectableDescription, Identifiable {
    public var id: Int {
        self.hashValue
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
    
    static func mockDone() -> RegisterState {
        .done(
            account: "account",
            password: "password",
            response: .mock()
        )
    }
}

extension RegisterState {
    func toDestination() -> Destination {
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

public enum Action {
    case passIntro
    case passOnboarding
    case passDone
    case removeDevices(Devices)
    case starLiveness
    case smsToken(String)
    case emailToken(String)
}

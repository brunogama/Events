//
//  RegisterState.swift
//  EventsPackage
//
//  Created by Bruno on 02/11/24.
//

public enum RegisterState: RawRepresentable, Equatable, Hashable, ReflectableDescription, Identifiable, Sendable{
    public var id: Int {
        UUID().uuidString
            .data(using: .utf8)!
            .bytes.count +
        instanceDescription
            .data(using: .utf8)!
            .bytes.count
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
    
    #if DEBUG
    package static func mockDone() -> RegisterState {
        .done(
            account: "account",
            password: "password",
            response: .mock()
        )
    }
    #endif
}

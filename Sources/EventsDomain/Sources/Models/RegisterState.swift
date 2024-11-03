//
//  RegisterState.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import Foundation

public enum RegisterState: RawRepresentable, Equatable, Hashable, ReflectableDescription, Identifiable, Sendable {
    private enum Constants {
        static let salt: String = {
            var random: RandomNumberGenerator = SystemRandomNumberGenerator()
            let salt = (0...5)
                .compactMap { _ in
                    UUID().uuidString
                }
                .joined()
                .shuffled(using: &random)
                .map { String($0) }
                .joined()
            
            return salt
        }()
    }
    public var id: Int {
        guard
            let saltByteCpunt = Constants.salt.data(using: .utf8)?.count,
            let uuidByteCount = UUID().uuidString.data(using: .utf8)?.count,
            let instanceInformationbyteCount = instanceDescription.data(using: .utf8)?.count
        else {
            return UUID().uuidString.count + instanceDescription.count + (0...Int.max).randomElement()!
        }

        return uuidByteCount + instanceInformationbyteCount
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

    #if DEBUG
        public static func mockDone() -> RegisterState {
            .done(
                account: "account",
                password: "password",
                response: .mock()
            )
        }
    #endif
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

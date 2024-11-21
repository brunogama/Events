//
//  Event.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import Foundation

public enum Event: Hashable, Equatable, ReflectableDescription, Identifiable, Sendable {
    public var id: String {
        UUID().uuidString
    }

    case idle
    case startProcessing
    case loading
    case willUpdateState(RegisterState)
    case stateUpdated(RegisterState)
    case error(ValidationError)

    public var name: String {
        let mirror = Mirror(reflecting: self)
        let casename = mirror.children.first?.label
        return casename ?? String(describing: self)
    }

    public static func == (lhrs: Event, rhs: Event) -> Bool {
        lhrs.instanceDescription == rhs.instanceDescription
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(instanceDescription)
    }

    public var isProcessing: Bool {
        switch self {
        case .stateUpdated, .idle, .error: return false
        default: return true
        }
    }

    public var simulationDelay: TimeInterval {
        switch self {
        case .loading: return .random(in: 0.5...1.5)
        case .startProcessing: return .random(in: 0.0...0.5)
        case .willUpdateState: return 0
        case .error: return 0
        case .idle: return 0
        case .stateUpdated: return 0
        }
    }

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
//        case .currentState:
//            return "stop.circle"
        }
    }
}

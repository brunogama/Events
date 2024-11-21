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
        "\(instanceDescription)-\(Date().timeIntervalSinceReferenceDate)"
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

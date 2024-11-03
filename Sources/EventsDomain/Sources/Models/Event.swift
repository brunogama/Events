//
//  Event.swift
//  EventsModule
//
//  Created by Bruno on 02/11/24.
//

import Foundation

public enum Event: Hashable, Equatable, ReflectableDescription, Identifiable, Sendable {
    public var id: String {
        UUID().uuidString + instanceDescription
    }
    
    case idle
    case startProcessing
    case loading
    case willUpdateState(RegisterState)
    case stateUpdated(RegisterState)
    case currentState(RegisterState)
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
    
    public var isProcessing: Bool {
        switch self {
        case .loading: return true
        case .startProcessing: return true
        case .willUpdateState: return true
        default: return false
        }
    }
    
    public var isIdle: Bool {
        self == .idle
    }
    
    public var willTransition: Bool {
        switch self {
        case .willUpdateState: return true
        case .stateUpdated: return true
        default: return false
        }
    }
    
    public var isDone: Bool {
        if case let .currentState(state) = self,
           case .done = state {
            return true
        }
        return false
    }
    
    public var hasError: Error? {
        if case let .error(error) = self {
            return error
        }
        return nil
    }
    
    public var currentState: RegisterState? {
        if case let .currentState(state) = self {
            return state
        }
        return nil
    }
    
    public var simulationDelay: Double {
        switch self {
        case .loading: return 1
        case .startProcessing: return 1
        case .willUpdateState: return 0.5
        case .currentState: return 0
        case .error: return 0
        case .idle: return 0
        case .stateUpdated: return 0
        }
    }
    
    public  var icon: String {
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
        case .currentState:
            return "stop.circle"
        }
    }
}

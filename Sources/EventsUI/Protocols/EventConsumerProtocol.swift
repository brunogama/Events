//
//  EventConsumerProtocol.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import Foundation
import SwiftUI

//public class EventStateManager {
//    private var cancellables = Set<AnyCancellable>()
//
//    // Expanded state tracking
//    public struct StateSnapshot {
//        public var currentEvent: Event
//        public var isProcessing: Bool
//        public var registerState: RegisterState?
//        public var lastError: Error?
//        public var timestamp: Date
//        public var processingDuration: TimeInterval?
//        public var consecutiveErrorCount: Int
//
//        public static var initial: StateSnapshot {
//            StateSnapshot(
//                currentEvent: .idle,
//                isProcessing: false,
//                timestamp: Date(),
//                consecutiveErrorCount: 0
//            )
//        }
//    }
//
//    public init(_ emitter: EventSender) {
//        setupStateTracking(emitter)
//        setupErrorTracking(emitter)
//        setupProcessingTimeTracking(emitter)
//    }
//
//    private func setupStateTracking(_ emitter: EventSender) {
//        // Main state tracker
//        emitter.eventSubject
//            .scan(StateSnapshot.initial) { state, newEvent in
//                var newState = state
//                newState.currentEvent = newEvent
//                newState.timestamp = Date()
//
//                switch newEvent {
//                case .idle:
//                    newState.isProcessing = false
//                    newState.processingDuration = nil
//
//                case .startProcessing, .loading:
//                    newState.isProcessing = true
//                    newState.lastError = nil
//
//                case .willUpdateState(let registerState):
//                    newState.isProcessing = true
//                    newState.registerState = registerState
//
//                case .stateUpdated(let registerState):
//                    newState.isProcessing = false
//                    newState.registerState = registerState
//                    newState.consecutiveErrorCount = 0
//
//                case .currentState(let registerState):
//                    newState.isProcessing = false
//                    newState.registerState = registerState
//                    newState.consecutiveErrorCount = 0
//
//                case .error(let error):
//                    newState.isProcessing = false
//                    newState.lastError = error
//                    newState.consecutiveErrorCount += 1
//                }
//
//                return newState
//            }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] state in
//                self?.handleStateUpdate(state)
//            }
//            .store(in: &cancellables)
//    }
//
//    private func setupErrorTracking(_ emitter: EventSender) {
//        // Track error patterns
//        emitter.eventSubject
//            .scan([]) { (errors: [Error], event: Event) -> [Error] in
//                if case .error(let error) = event {
//                    return (errors + [error]).suffix(3)  // Keep last 3 errors
//                }
//                return errors
//            }
//            .filter { !$0.isEmpty }
//            .sink { [weak self] errors in
//                self?.handleErrorPattern(errors)
//            }
//            .store(in: &cancellables)
//    }
//
//    private func setupProcessingTimeTracking(_ emitter: EventSender) {
//        // Track processing time
//        emitter.eventSubject
//            .scan((startTime: Optional<Date>.none, event: Event.idle)) { state, newEvent in
//                var startTime = state.startTime
//
//                if newEvent.isProcessing && startTime == nil {
//                    startTime = Date()
//                }
//                else if !newEvent.isProcessing {
//                    startTime = nil
//                }
//
//                return (startTime: startTime, event: newEvent)
//            }
//            .compactMap { state -> TimeInterval? in
//                guard !state.event.isProcessing,
//                    let start = state.startTime
//                else {
//                    return nil
//                }
//                return Date().timeIntervalSince(start)
//            }
//            .sink { [weak self] duration in
//                self?.handleProcessingComplete(duration: duration)
//            }
//            .store(in: &cancellables)
//    }
//    // MARK: - State Handlers
//
//    private func handleStateUpdate(_ state: StateSnapshot) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            // Handle state transitions
//            if state.isProcessing {
//                print("📍 Processing: \(state.currentEvent.name)")
//            }
//            else {
//                print("✅ Completed: \(state.currentEvent.name)")
//            }
//
//            // Handle register state updates
//            if let registerState = state.registerState {
//                print("📝 Register State Updated: \(registerState)")
//            }
//
//            // Handle errors with retry logic
//            if let error = state.lastError {
//                handleError(error, consecutiveErrors: state.consecutiveErrorCount)
//            }
//        }
//    }
//
//    private func handleErrorPattern(_ errors: [Error]) {
//        if errors.count >= 3 {
//            print("⚠️ Warning: Multiple consecutive errors detected")
//            // Implement recovery strategy
//        }
//    }
//
//    private func handleProcessingComplete(duration: TimeInterval) {
//        if duration > 5.0 {
//            print("⚠️ Warning: Processing took longer than expected: \(duration) seconds")
//        }
//        print("ℹ️ Processing completed in \(String(format: "%.2f", duration)) seconds")
//    }
//
//    private func handleError(_ error: Error, consecutiveErrors: Int) {
//        print("❌ Error: \(error)")
//
//        // Implement retry logic based on consecutive errors
//        switch consecutiveErrors {
//        case 1:
//            retryImmediate()
//        case 2:
//            retryWithDelay(seconds: 1)
//        case 3...:
//            handleCriticalError(error)
//        default:
//            break
//        }
//    }
//
//    // MARK: - Recovery Methods
//
//    private func retryImmediate() {
//        //        eventPublisher.send(.startProcessing)
//    }
//
//    private func retryWithDelay(seconds: TimeInterval) {
//        //        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
//        //            self?.eventPublisher.send(.startProcessing)
//        //        }
//    }
//
//    private func handleCriticalError(_ error: Error) {
//        print("🚨 Critical error: Too many retry attempts")
//        // Implement recovery strategy or notify user
//    }
//}

@MainActor
public protocol EventConsumerProtocol: AnyObject, ObservableObject {
    var event: Event { get }
    var cancellables: Set<AnyCancellable> { get set }
    var action: Action { get }
    var receivedValue: Event { get set }
    var isProcessing: Bool { get set }
    var receivedValues: [Event] { get set }
    var emitter: EventSender? { get set }
    var title: String { get }
    var buttonTitle: String { get }
    var renderInputTextField: Bool { get }

    func registerActiveView(_ viewId: String)
    func unregisterView(_ viewId: String)
    func receivedEvent(_ event: Event)
    func appendEvent(_ value: Event)
    func proccessAction(_ action: Action)
    func buttonTap()
}

private let lock = NSLock()

extension EventConsumerProtocol {
    public var title: String { "Base" }
    public var buttonTitle: String { "Send Event" }
    public var renderInputTextField: Bool { false }
    public var action: Action { .passIntro }

    public func receivedEvent(_ event: EventsDomain.Event) {
        Logger.info("Event received EventConsumerBaseViewModel")
        Logger.info("Classe atual \(String(describing: self))")
    }

    public func registerActiveView(_ viewId: String) {
        emitter?.registerActiveView(viewId)
        emitter?.createPublisher(for: viewId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.appendEvent(event)
            }
            .store(in: &cancellables)
    }

    public func unregisterView(_ viewId: String) {
        emitter?.unregisterView(viewId)
        unbind()
    }

    public func appendEvent(_ value: Event) {
        isProcessing = value.isProcessing
        receivedValue = value
        lock.lock()
        receivedValues.append(value)
        lock.unlock()
    }
    @MainActor 
    public func proccessAction(_ action: Action) {
        emitter?.proccessAction(action)
    }

    public func buttonTap() {
        proccessAction(self.action)
    }

    public func unbind() {
        cancellables.removeAll()
    }
}

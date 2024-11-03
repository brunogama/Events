//
//  EventSender.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import Foundation

public class EventSender: @unchecked Sendable {

    public let passthroughSubject = CurrentValueSubject<Event, Never>(.idle)

    public var eventSubject = CurrentValueSubject<Event, Never>(.idle)

    public init() {}

    public func emit(_ event: Event) {
        eventSubject.send(event)
    }

    @MainActor
    public func proccessAction(_ action: Action) {
        switch action {
        case .passIntro:
            fakeActionProcessing(.onboarding)
        case .passOnboarding:
            fakeActionProcessing(.removeDevices(.mock()))
        case .passDone:
            fakeActionProcessing(.onboarding)
        case .removeDevices(_):
            fakeActionProcessing(.liveness(.implementationB(.mock())))
        case .starLiveness:
            fakeActionProcessing(.sms)
        case .smsToken:
            fakeActionProcessing(.email)
        case .emailToken(_):
            fakeActionProcessing(.mockDone())
        }
    }

    @MainActor
    private func fakeActionProcessing(_ registerState: RegisterState) {
        let eventsSimulation = [
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
            .currentState(registerState),
        ]
        Task {
            for event in eventsSimulation {
                await delay(event.simulationDelay) { [weak self] in
                    self?.emit(event)
                }
            }
        }
    }

    private func delay(
        _ delay: Int = (0...2).randomElement()!,
        closure: @escaping @Sendable () -> Void
    ) async {
        await Task.delayFor(seconds: delay)
        closure()
    }

    public func resetState() {
        eventSubject.send(.idle)
    }
}

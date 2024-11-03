//
//  EventSender.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import Foundation

public class EventSender: @unchecked Sendable {
    
    let passthroughSubject = CurrentValueSubject<Event, Never>(.idle)
    
    var eventSubject = CurrentValueSubject<Event, Never>(.idle)
    
    init() {}
    
    func emit(_ event: Event) {
        eventSubject.send(event)
    }
    
    func proccessAction(_ action: Action) {
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
    
    private func fakeActionProcessing(_ registerState: RegisterState) {
        let eventsSimulation = [
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
            .currentState(registerState),
        ]
        
        for event in eventsSimulation {
            await delay(step.simulationDelay)
            self?.emit(step)
        }
    }
    
    private func delay(
        _ delay: UInt64 = (0...2).randomElement().map(UInt64)!,
        closure: @escaping (@Sendable () -> Void)? = nil
    ) async {
        try? await Task.sleep(delay)
        closure()
    }
    
    
    public func resetState() {
        eventSubject.send(.idle)
    }
}


@available(SwiftStdlib 5.9, *)
package extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
    }
}

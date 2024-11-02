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
    var eventSubject: AnyPublisher<Event, Never> {
        passthroughSubject.eraseToAnyPublisher()
    }
    
    init() {}
    
    func emit(_ event: Event) {
        passthroughSubject.send(event)
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
        let pipeline = [
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
        ]
        
        for step in pipeline {
            delay { [weak self] in
                self?.emit(step)
            }
        }
    }

    private func delay(
        _ delay: Double = Double((1...3).randomElement()!),
        closure: @escaping @Sendable () -> Void
    ) {
        Task {
            try await Task.sleep(seconds: Int(delay))
            closure()
        }
    }

}

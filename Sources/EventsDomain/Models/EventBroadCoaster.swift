//
//  EventSender.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import Foundation

public final class EventBroadCoaster {
    private let eventBroadcasterSubject = PassthroughSubject<Event, Never>()

    public init() {}

    public func emit(_ event: Event) {
        eventBroadcasterSubject.send(event)
    }

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

    private func fakeActionProcessing(_ registerState: RegisterState) {
        var eventsSimulation = [
            Event.startProcessing,
            .loading,
        ]
        
        if Int.random(in: 1...10) > 5 {
            eventsSimulation += [
                .willUpdateState(registerState),
                .stateUpdated(registerState),
                .stateUpdated(registerState)
            ]
        } else {
            eventsSimulation.append(.error(.empty))
        }

        Task {
            await withTaskGroup(of: Void.self) { group in
                for event in eventsSimulation {
                    group.addTask {
                        await Task.delayFor(for: event.simulationDelay)
                        self.emit(event)
                    }
                    await group.next()
                }
            }
        }
    }

    public func subscribe(
            owner: any IdentifiableObservableObjectProtocol,
            handler: @escaping (Event) -> Void
        ) -> SubscriptionToken {
            
            let token = SubscriptionToken()
            
            let cancellable = eventBroadcasterSubject
                .receive(on: DispatchQueue.main)
                .sink { [weak owner] event in
                    guard let owner = owner else { return }
                    handler(event)
                }
            
            token.store(cancellable)
            return token
        }
}

private extension Event {
    var simulationDelay: TimeInterval {
        switch self {
        case .loading: return .random(in: 0.5...1.5)
        case .startProcessing: return .random(in: 0.0...0.5)
        case .willUpdateState: return 0
        case .error: return 0
        case .idle: return 0
        case .stateUpdated: return 0
        }
    }
}

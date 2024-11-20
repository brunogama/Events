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
    private var cleanupCancellable: AnyCancellable?

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
        let eventsSimulation = [
            Event.loading,
            .stateUpdated(registerState),
        ]

        Task {
            await withTaskGroup(of: Void.self) { group in
                for event in eventsSimulation {
                    group.addTask {
                        await Task.delayFor(seconds: Int.random(in: 0...2))
                        await MainActor.run {
                            self.emit(event)
                        }
                    }
                    await group.next()
                }
            }
            await Task.delayFor(seconds: 1)
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
    
    deinit {
        cleanupCancellable?.cancel()
        cleanupCancellable = nil
    }
}

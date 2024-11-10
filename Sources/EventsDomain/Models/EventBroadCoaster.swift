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
    private var activeConsumers: [String: WeakBox] = [:]
    
    private class WeakBox {
        weak var value: (any IdentifiableObservableObjectProtocol)?
        
        init(_ value: any IdentifiableObservableObjectProtocol) {
            self.value = value
        }
    }
    
    public init() {}
    
    @MainActor public func emit(_ event: Event) {
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
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
        ]
        
        Task {
            await withTaskGroup(of: Void.self) { group in
                for event in eventsSimulation {
                    group.addTask {
                        await Task.delayFor(seconds: event.simulationDelay)
                        await MainActor.run {
                            self.emit(event)
                        }
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
        
        activeConsumers[owner.objectId] = WeakBox(owner)
        
        let cancellable = eventBroadcasterSubject
            .receive(on: DispatchQueue.main)
            .filter { [weak self, weak owner] _ in
                guard let owner = owner, let self, self.activeConsumers[owner.objectId]?.value != nil else {
                    return false
                }
                return true
            }
            .handleEvents(receiveCancel: { [weak self, weak owner] in
                guard let owner = owner else { return }
                self?.activeConsumers.removeValue(forKey: owner.objectId)
                Logger.info("Consumer removed: \(owner.objectId)")
            })
            .sink { [weak owner] event in
                guard let owner = owner else { return }
                Logger.info("Processing event for: \(owner.objectId)")
                handler(event)
            }
        
        token.store(cancellable)
        return token
    }
}

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
    private var lastEvent: Event = .idle
    private var activeConsumers: [String: WeakBox] = [:] {
        didSet {
            cleanupStaleReferences()
        }
    }

    private final class WeakBox {
        weak var value: (any IdentifiableObservableObjectProtocol)?
        let timestamp: Date

        init(_ value: any IdentifiableObservableObjectProtocol) {
            self.value = value
            self.timestamp = Date()
        }

        var isStale: Bool {
            value == nil
        }
    }

    public init() {}

    @MainActor public func emit(_ event: Event) {
        lastEvent = event
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
        cleanupStaleReferences()

        // Cancel existing subscription if any
        if let existingBox = activeConsumers[owner.objectId], existingBox.value === owner {
            Logger.debug("Replacing existing subscription for: \(owner.objectId)")
        }

        let token = SubscriptionToken()
        activeConsumers[owner.objectId] = WeakBox(owner)

        let cancellable =
            eventBroadcasterSubject
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCancel: { [weak self, weak owner] in
                guard let self = self,
                    let owner = owner
                else { return }

                self.activeConsumers.removeValue(forKey: owner.objectId)
                Logger.debug("Subscription cancelled for: \(owner.objectId)")
            })
            .filter { [weak owner] _ in
                // Only deliver events if the owner is still alive
                owner != nil
            }
            .sink { [weak owner] event in
                guard let owner = owner else { return }
                Logger.debug("Processing event for: \(owner.objectId)")
                handler(event)
            }

        token.store(cancellable)
        return token
    }

    private func cleanupStaleReferences() {
        let staleKeys = activeConsumers.filter { $0.value.isStale }.keys
        staleKeys.forEach { activeConsumers.removeValue(forKey: $0) }

        if !staleKeys.isEmpty {
            Logger.debug("Cleaned up \(staleKeys.count) stale references")
        }
    }

    #if DEBUG
        public func getCurrentState() -> Event {
            lastEvent
        }

        public func getActiveConsumerCount() -> Int {
            activeConsumers.count
        }
    #endif
}

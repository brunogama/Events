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
    private var cleanupCancellable: AnyCancellable?

    private var activeConsumers: [String: WeakBox] = [:] {
        didSet {
            cleanupStaleReferences()
        }
    }

    private final class WeakBox {
        weak var value: (any IdentifiableObservableObjectProtocol)?
        let timestamp: Date
        var lastEventTimestamp: Date?

        init(_ value: any IdentifiableObservableObjectProtocol) {
            self.value = value
            self.timestamp = Date()
        }

        var isStale: Bool {
            value == nil
        }
    }

    public init() {
        setupPeriodicCleanup()
    }

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

        let token = SubscriptionToken()
        let box = WeakBox(owner)
        activeConsumers[owner.objectId] = box

        let cancellable =
            eventBroadcasterSubject
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveOutput: { [weak box] _ in
                    box?.lastEventTimestamp = Date()
                },
                receiveCancel: { [weak self, weak owner] in
                    guard let owner = owner else { return }
                    self?.activeConsumers.removeValue(forKey: owner.objectId)
                }
            )
            .filter { [weak owner] _ in
                owner != nil
            }
            .sink { [weak owner] event in
                guard let owner = owner else { return }
                handler(event)
            }

        token.store(cancellable)
        return token
    }

    private func setupPeriodicCleanup() {
        cleanupCancellable = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.cleanupStaleReferences()
            }
    }

    private func cleanupStaleReferences() {
        let staleKeys = activeConsumers.filter { $0.value.isStale }.keys
        staleKeys.forEach { activeConsumers.removeValue(forKey: $0) }
        
        #if DEBUG
        if !staleKeys.isEmpty {
            print("Cleaned up \(staleKeys.count) stale references")
        }
        #endif
    }
    
    deinit {
        cleanupCancellable?.cancel()
        cleanupCancellable = nil
    }
}

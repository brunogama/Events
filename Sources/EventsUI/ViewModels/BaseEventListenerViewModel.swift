//
//  EventConsumerBaseViewModel.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import Foundation

open class BaseEventListenerViewModel: EventListenerProtocol {
    @Published public var receivedValues: [Event] = []
    @Published public var event: Event = .idle
    public let eventBroadcaster: EventBroadCoaster
    open var action: Action { .passDone }
    open var title: String { "" }
    open var buttonTitle: String { "" }
    open var image: String { "" }

    private var subscriptionToken: SubscriptionToken?
    private var cleanupCancellable: AnyCancellable?

    public init(eventBroadcaster: EventBroadCoaster) {
        self.eventBroadcaster = eventBroadcaster
        registerActive()
    }

    public func registerActive() {
        subscriptionToken?.cancel()
        guard subscriptionToken == nil else { return }
        subscriptionToken = eventBroadcaster.subscribe(owner: self) { [weak self] newEvent in
            self?.registerEvent(newEvent)
        }
    }

    open func registerEvent(_ event: Event) {
        self.event = event
        receivedValues.append(event)

        if case .stateUpdated(let registerState) = event {
            // Cancel any existing cleanup
            cleanupCancellable?.cancel()

            // Create new cleanup task
            cleanupCancellable = Just(())
                .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.unregisterActive()
                }
        }
    }

    open func unregisterActive() {
        Logger.debug("Unregistering \(self)")
        subscriptionToken?.cancel()
        subscriptionToken = nil
        cleanupCancellable?.cancel()
        cleanupCancellable = nil
    }

    public func buttonTap() {
        proccessAction()
    }

    private func proccessAction() {
        eventBroadcaster.proccessAction(action)
    }

    deinit {
        unregisterActive()
    }
}

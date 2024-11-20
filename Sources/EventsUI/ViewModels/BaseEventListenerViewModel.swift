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
    private(set) public var navigationDestinationObserver: NavigationObservableDestination
    public private(set) weak var eventBroadcaster: EventBroadCoaster?
    open var action: Action { .passDone }
    open var title: String { "" }
    open var buttonTitle: String { "" }
    open var image: String { "" }

    private var subscriptionToken: SubscriptionToken?
    private var completedStateFlags: StateFlags = []
    private var currentDependency: DeferredDependency?

    public init(
        eventBroadcaster: EventBroadCoaster,
        navigationDestinationObserver: NavigationObservableDestination
    ) {
        self.navigationDestinationObserver = navigationDestinationObserver
        self.eventBroadcaster = eventBroadcaster
        registerActive()
    }

    public func registerActive() {
//        subscriptionToken?.cancel()
//        guard subscriptionToken == nil else { return }
//        Logger.debug("🔌 Registering \(self)")
        guard let eventBroadcaster else { return }
        subscriptionToken = eventBroadcaster.subscribe(owner: self) { [weak self] newEvent in
            self?.registerEvent(newEvent)
        }
    }

    open func registerEvent(_ event: Event) {
        self.event = event
        receivedValues.append(event)

        if case .stateUpdated(let newState) = event {
            navigationDestinationObserver.state = newState
            handleStateTransition(for: newState)
        }
    }

    private func handleStateTransition(for state: RegisterState) {
        completedStateFlags.insert(state.stateFlag)

        let dependency = state.deferredDependency
        if case .none = dependency {
            unregisterActive()
            return
        }

        if currentDependency == nil {
            currentDependency = dependency
        }

        if isDependencySatisfied() {
            unregisterActive()
        }

        #if DEBUG
            logDependencyStatus()
        #endif
    }

    private func isDependencySatisfied() -> Bool {
        guard let dependency = currentDependency else { return true }

        switch dependency {
        case .none:
            return true

        case .all(let flags):
            return completedStateFlags.contains(flags)

        case .any(let flags):
            return !completedStateFlags.intersection(flags).isEmpty

        case .either(let flags1, let flags2):
            return completedStateFlags.contains(flags1) || completedStateFlags.contains(flags2)
        }
    }

    #if DEBUG
        private func logDependencyStatus() {
            print("Completed states: \(completedStateFlags)")
            print("Dependencies satisfied: \(isDependencySatisfied())")
        }
    #endif

    open func unregisterActive() {
//        Logger.debug("Unregistering \(self)")
        completedStateFlags = []
        currentDependency = nil
        subscriptionToken?.cancel()
        subscriptionToken = nil
    }

    public func buttonTap() {
        proccessAction()
    }

    private func proccessAction() {
        eventBroadcaster?.proccessAction(action)
    }

    deinit {
        Logger.debug("De-initing \(self)")
        unregisterActive()
    }
}

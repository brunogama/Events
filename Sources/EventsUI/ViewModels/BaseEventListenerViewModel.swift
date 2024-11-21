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
    open var state: StateFlags { .none }
    open var defferUnsubcription: DeferredDependency { .none }

    private var subscriptionToken: SubscriptionToken?
    private var completedStateFlags: StateFlags = []
    private var originalDefferedFlag: StateFlags = .intro

    public init(
        eventBroadcaster: EventBroadCoaster,
        navigationDestinationObserver: NavigationObservableDestination
    ) {
        self.navigationDestinationObserver = navigationDestinationObserver
        self.eventBroadcaster = eventBroadcaster
        registerActive()
    }

    public func registerActive() {
        subscriptionToken?.cancel()
        guard subscriptionToken == nil else { return }
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

        let stateDependency = state.deferredDependency

        #if DEBUG
            logDependencyStatus(state: state, dependency: stateDependency)
        #endif

        if isDependencySatisfied() {
            unregisterActive()
        }
    }

    private func isDependencySatisfied() -> Bool {
        switch defferUnsubcription {
        case .none:
            return true

        case .all(let flags):
            let result = flags.rawValue & completedStateFlags.rawValue == flags.rawValue
            Logger.debug("🎯 All flags in \(type(of: self)) check: required \(flags), have \(completedStateFlags), satisfied: \(result)")
            return result

        case .any(let flags):
            let result = (flags.rawValue & completedStateFlags.rawValue) != 0
            Logger.debug("🎯 Any flags in \(type(of: self)) check: required \(flags), have \(completedStateFlags), satisfied: \(result)")
            return result

        case .either(let flags1, let flags2):
            let result1 = flags1.rawValue & completedStateFlags.rawValue == flags1.rawValue
            let result2 = flags2.rawValue & completedStateFlags.rawValue == flags2.rawValue
            Logger.debug(
                "🎯 Either flags in \(type(of: self)) check: required \(flags1) or \(flags2), have \(completedStateFlags), satisfied: \(result1 || result2)"
            )
            return result1 || result2
        }
    }

    #if DEBUG
        private func logDependencyStatus(
            state: RegisterState,
            dependency: DeferredDependency
        ) {
            if dependency == .none {
                return
            }

            print("📍 \(type(of: self)) State Update:")
            print("   Current State: \(state)")
            print("   Completed Flags: \(completedStateFlags)")
            print("   State Dependency: \(dependency)")
            print("   Dependencies Satisfied: \(isDependencySatisfied())")
        }
    #endif

    open func unregisterActive() {
        Logger.debug("Unregistering \(self)")
        completedStateFlags = []
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
        //        Logger.debug("De-initing \(self)")
        unregisterActive()
    }
}

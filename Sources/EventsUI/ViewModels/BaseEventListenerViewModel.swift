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
    
    private var _subscriptionToken: SubscriptionToken?
    private var subscriptionToken: SubscriptionToken? {
        get {
            _subscriptionToken
        }
        set {
            _subscriptionToken = newValue
        }
    }

    public init(eventBroadcaster: EventBroadCoaster) {
        self.eventBroadcaster = eventBroadcaster
        registerActive()
    }
    
    public func registerActive() {
        guard subscriptionToken == nil else { return }
        subscriptionToken = eventBroadcaster.subscribe(owner: self) { [weak self] newEvent in
            self?.eventHandler(newEvent)
        }
    }
    
    private func eventHandler(_ event: Event) {
        registerEvent(event)
    }
    
    public func registerEvent(_ event: Event) {
        self.event = event
        receivedValues.append(event)
        
        if case .stateUpdated(let registerState) = event {
            unregisterActive()
        }
    }
    
    open func unregisterActive() {
        subscriptionToken?.cancel()
        subscriptionToken = nil
    }
    
    public func buttonTap() {
        proccessAction()
    }
    
    private func proccessAction() {
        eventBroadcaster.proccessAction(action)
    }
}

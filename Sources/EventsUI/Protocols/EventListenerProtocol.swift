//
//  EventConsumerProtocol.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import Foundation
import SwiftUI

public protocol EventListenerProtocol: IdentifiableObservableObjectProtocol {
    var event: Event { get }
    var action: Action { get }
    var receivedValues: [Event] { get set }
    var eventBroadcaster: EventBroadCoaster { get }
    var title: String { get }
    var buttonTitle: String { get }
    var image: String { get }
    var navigationDestinationObserver: NavigationObservableDestination { get }
    func registerActive()
    func registerEvent(_ event: Event)
    func unregisterActive()
    func buttonTap()
}

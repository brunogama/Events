//
//  EventConsumer.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsDomain
import Foundation

public final class EventConsumer: EventConsumerBaseViewModel {

    public func receive(_ value: Event) {
        print("EventConsumer received: \(String(describing: value).uppercased())")
    }
}

//
//  EventConsumer.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import Foundation

final class EventConsumer: EventConsumerBaseViewModel {

    func receive(_ value: Event) {
        print("EventConsumer received: \(String(describing: value).uppercased())")
    }
}
    

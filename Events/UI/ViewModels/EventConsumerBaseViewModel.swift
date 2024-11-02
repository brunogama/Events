//
//  EventConsumerBaseViewModel.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Foundation
import Combine

open class EventConsumerBaseViewModel: EventConsumerProtocol, ObservableObject {    
    var cancellable: AnyCancellable?
    var cancellables: Set<AnyCancellable> = []
    var action: Action { fatalError("should override") }
    var isBeingShown: Bool? = nil 
    
    @Published var receivedValues: [Event] = []
    @Published var receivedValue: Event = .idle
    @Published var isProcessing: Bool = false
    
    var emitter: EventSender?
    var title: String { "Base" }
    var buttonTitle: String { "Send Event" }
    var image: String { "globe" }
    
    init(emitter: EventSender) {
        self.emitter = emitter
        bind(to: emitter)
    }
}


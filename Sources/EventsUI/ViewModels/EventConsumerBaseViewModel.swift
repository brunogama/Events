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

open class EventConsumerBaseViewModel: EventConsumerProtocol, ObservableObject {
    @Published private(set) public var event: Event = .idle
    public var cancellables: Set<AnyCancellable> = []
    public var action: Action { fatalError("should override") }

    @MainActor @Published public var receivedValues: [Event] = []
    @MainActor @Published public var receivedValue: Event = .idle
    @MainActor @Published public var isProcessing: Bool = false
    public var emitter: EventSender?
    public var title: String { "Base" }
    public var buttonTitle: String { "Send Event" }
    public var image: String { "globe" }
    public init(emitter: EventSender) {
        self.emitter = emitter
    }
}

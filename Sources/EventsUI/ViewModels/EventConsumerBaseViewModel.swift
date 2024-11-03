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

    @Published public var receivedValues: [Event] = []
    @Published public var receivedValue: Event = .idle
    @Published public var isProcessing: Bool = false
    public var emitter: EventSender?
    public var title: String { "Base" }
    public var buttonTitle: String { "Send Event" }
    public var image: String { "globe" }
    public init(emitter: EventSender) {
        self.emitter = emitter
        //        self.eventManager = EventStateManager(emitter)
        //        bind(to: emitter)
        //        setupExtraSubscriptions(emitter)
    }

    //    private func setupExtraSubscriptions(_ emitter: EventSender) {
    //        let visibilityState =
    //            lifecycle
    //            .scan(false) { isVisible, event in
    //                switch event {
    //                case .appeared: return true
    //                case .disappeared: return false
    //                }
    //            }
    //            .removeDuplicates()
    //            .share()
    //
    //        emitter.eventSubject
    //            .combineLatest(visibilityState)
    //            .filter { _, isVisble in isVisble }
    //            .map { event, _ in event }
    //            .removeDuplicates()
    //            .buffer(size: 5, prefetch: .byRequest, whenFull: .dropOldest)
    //            .dropFirst()
    //            .receive(on: DispatchQueue.main)
    //            .sink { [weak self] in
    //                self?.appendEvent($0)
    //            }
    //            .store(in: &cancellables)
    //    }
    //
    //    public func viewDidAppear() {
    //        lifecycle.send(.appeared)
    //    }
    //
    //    public func viewDidDisappear() {
    //        lifecycle.send(.disappeared)
    //    }
}

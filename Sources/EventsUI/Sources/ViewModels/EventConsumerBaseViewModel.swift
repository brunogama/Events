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
    enum ViewLifecycle {
        case appeared
        case disappeared
    }
    
    private let lifecycle = PassthroughSubject<ViewLifecycle, Never>()

    
    @Published var receivedValues: [Event] = []
    @Published var receivedValue: Event = .idle
    @Published var isProcessing: Bool = false
    
    var emitter: EventSender?
    var title: String { "Base" }
    var buttonTitle: String { "Send Event" }
    var image: String { "globe" }
    init(emitter: EventSender) {
        self.emitter = emitter
//        self.eventManager = EventStateManager(emitter)
        bind(to: emitter)
    }
    
    private func setupExtraSubscriptions(_ emitter: EventSender) {
        let visibilityState = lifecycle
            .scan(false) { isVisible, event in
                switch event {
                case .appeared: return true
                case .disappeared: return false
                }
            }.removeDuplicates()
            .share()
        
        emitter.eventSubject
            .combineLatest(visibilityState)
            .filter { _, isVisble in isVisble }
            .map { event, _ in event }
            .removeDuplicates()
            .buffer(size: 5, prefetch: .byRequest, whenFull: .dropOldest)
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.appendEvent($0)
            }.store(in: &cancellables)
    }
    
    func viewDidAppear() {
        lifecycle.send(.appeared)
    }
    
    func viewDidDisappear() {
        lifecycle.send(.disappeared)
    }
}


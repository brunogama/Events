//
//  EventConsumerProtocol.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//


import Combine
import SwiftUI

protocol EventConsumerProtocol: AnyObject, ObservableObject {
    var cancellable: AnyCancellable? { get set }
    var cancellables: Set<AnyCancellable> { get set }
    var action: Action { get }
    var isBeingShown: Bool? { get set }
    
    var receivedValue: Event { get set }
    var isProcessing: Bool { get set }
    var receivedValues: [Event] { get set }
    var emitter: EventSender? { get set }
    
    var title: String { get }
    var buttonTitle: String { get }
    var renderInputTextField: Bool { get }
    
    func bind(to emitter: EventSender)
    func receivedEvent(_ event: Event)
    func appendEvent(_ value: Event)
    func proccessAction(_ action: Action)
    func buttonTap()
    func unbind()
}

extension EventConsumerProtocol {
    var title: String { "Base" }
    var buttonTitle: String { "Send Event" }
    var renderInputTextField: Bool { false }
    var action: Action { .passIntro }
    
    func bind(to emitter: EventSender) {
        emitter.eventSubject
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.appendEvent(value)
                self?.receivedEvent(value)
                print("EventConsumerProtocol received: \(value)")
            })
            .store(in: &cancellables)
    }
    
    func receivedEvent(_ event: Event) {
        guard let isBeingShown, isBeingShown else { return }
        print("EventConsumerProtocol received: \(event)")
        print("Executing on class \(String(describing: type(of: self))).")
    }
    
    func appendEvent(_ value: Event) {
        isProcessing = value.isProcessing
        receivedValue = value
        receivedValues.append(value)
    }
    
    func proccessAction(_ action: Action) {
        emitter?.proccessAction(action)
    }
    
    func buttonTap() {
        proccessAction(self.action)
    }
    
    func unbind() {
//        cancellable?.cancel()
//        cancellable = nil
//        cancellables.removeAll()
    }
}

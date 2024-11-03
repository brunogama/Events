//
//  EventSender.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import Foundation

public class EventSender: @unchecked Sendable {
    private var cancellables = Set<AnyCancellable>()
    private let stateSubject = PassthroughSubject<Event, Never>()
    private var activeViews: Set<String> = []
    private let lock = NSLock()

    public init() {}

    public func emit(_ event: Event) {
        stateSubject.send(event)
    }

    @MainActor
    public func proccessAction(_ action: Action) {
        switch action {
        case .passIntro:
            fakeActionProcessing(.onboarding)
        case .passOnboarding:
            fakeActionProcessing(.removeDevices(.mock()))
        case .passDone:
            fakeActionProcessing(.onboarding)
        case .removeDevices(_):
            fakeActionProcessing(.liveness(.implementationB(.mock())))
        case .starLiveness:
            fakeActionProcessing(.sms)
        case .smsToken:
            fakeActionProcessing(.email)
        case .emailToken(_):
            fakeActionProcessing(.mockDone())
        }
    }

    @MainActor
    private func fakeActionProcessing(_ registerState: RegisterState) {
        defer { lock.unlock() }
        lock.lock()
        let eventsSimulation = [
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
            .currentState(registerState),
        ]
        Task {
            for event in eventsSimulation {
                await delay(event.simulationDelay) { [weak self] in
                    self?.emit(event)
                }
            }
        }
    }

    public func createPublisher(for viewId: String) -> AnyPublisher<Event, Never> {
        defer { lock.unlock() }
        lock.lock()
        Logger.info("Binding no id`1 \(viewId)")
        return
            stateSubject
            .removeDuplicates { $0 == $1 }
            .receive(on: DispatchQueue.main)
            .filter { [weak self] _ in
                self?.isViewActive(viewId) ?? false
            }
            .share()
            .eraseToAnyPublisher()
    }

    public func registerActiveView(_ viewId: String) {
        Logger.info("Adicionando a lista de subscription \(viewId)")
        addActiveView(viewId)
    }

    public func unregisterView(_ viewId: String) {
        Logger.info("Removendo da lista de subscription \(viewId)")
        removeActiveView(viewId)
    }

    private func isViewActive(_ viewId: String) -> Bool {
        getactiveViews().contains(viewId)
    }
    
    private func removeActiveView(_ viewId: String) {
        defer { lock.unlock() }
        lock.lock()
        activeViews.remove(viewId)
    }
    
    private func addActiveView(_ viewId: String) {
        defer { lock.unlock() }
        lock.lock()
        activeViews.insert(viewId)
    }
    
    private func getactiveViews() -> Set<String> {
        defer { lock.unlock() }
        lock.lock()
        return activeViews
    }

    private func delay(
        _ delay: Int = (0...2).randomElement()!,
        closure: @escaping @Sendable () -> Void
    ) async {
        await Task.delayFor(seconds: delay)
        closure()
    }
}

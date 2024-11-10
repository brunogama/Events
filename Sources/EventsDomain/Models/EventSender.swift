//
//  EventSender.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import Foundation

public final class EventSender {
    private var cancellables = Set<AnyCancellable>()
    private let stateSubject = PassthroughSubject<Event, Never>()
    private var activeViews: Set<String> = []

    public init() {}

    @MainActor
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

    @MainActor private func fakeActionProcessing(_ registerState: RegisterState) {
        let eventsSimulation = [
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
        ]
        
        Task {
            await withTaskGroup(of: Void.self) { group in
                for event in eventsSimulation {
                    group.addTask {
                        await Task.delayFor(seconds: event.simulationDelay)
                        await MainActor.run {
                            self.emit(event)
                        }
                    }
                    await group.next()
                }
            }
        }
    }

    @MainActor
    public func createPublisher(for viewId: String) -> AnyPublisher<Event, Never> {
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

    @MainActor public func registerActiveView(_ viewId: String) {
        Logger.info("Adicionando a lista de subscription \(viewId)")
        activeViews.insert(viewId)
    }

    @MainActor public func unregisterView(_ viewId: String) {
        Logger.info("Removendo da lista de subscription \(viewId)")
        activeViews.remove(viewId)
    }

    @MainActor private func isViewActive(_ viewId: String) -> Bool {
        activeViews.contains(viewId)
    }
}

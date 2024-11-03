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

    public init() {}

    public func emit(_ event: Event) {
        stateSubject.send(event)
    }

    public func proccessAction(_ action: Action) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch action {
            case .passIntro:
                self.fakeActionProcessing(.onboarding)
            case .passOnboarding:
                self.fakeActionProcessing(.removeDevices(.mock()))
            case .passDone:
                self.fakeActionProcessing(.onboarding)
            case .removeDevices(_):
                self.fakeActionProcessing(.liveness(.implementationB(.mock())))
            case .starLiveness:
                self.fakeActionProcessing(.sms)
            case .smsToken:
                self.fakeActionProcessing(.email)
            case .emailToken(_):
                self.fakeActionProcessing(.mockDone())
            }
        }
    }

    private func fakeActionProcessing(_ registerState: RegisterState) {
        let eventsSimulation = [
            Event.startProcessing,
            .loading,
            .willUpdateState(registerState),
            .stateUpdated(registerState),
            .currentState(registerState),
        ]
        Task { @MainActor [weak self] in
            guard let self else { return }
            for event in eventsSimulation {
                await Task.delayFor(seconds: event.simulationDelay)
                emit(event)
            }
        }
    }

    public func createPublisher(for viewId: String) -> AnyPublisher<Event, Never> {
        Logger.info("Binding no id`1 \(viewId)")
        return
            stateSubject
            .receive(on: DispatchQueue.main)
            .filter { [weak self] _ in
                self?.isViewActive(viewId) ?? false
            }
            .share()
            .eraseToAnyPublisher()
    }

    public func registerActiveView(_ viewId: String) {
        Logger.info("Adicionando a lista de subscription \(viewId)")
        activeViews.insert(viewId)
    }

    public func unregisterView(_ viewId: String) {
        Logger.info("Removendo da lista de subscription \(viewId)")
        activeViews.remove(viewId)
    }

    private func isViewActive(_ viewId: String) -> Bool {
        activeViews.contains(viewId)
    }
}

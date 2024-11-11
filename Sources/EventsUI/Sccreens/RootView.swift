//
//  ContentView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct RootView: EventObservableViewProtocol {
    public let viweId = "ContentView"
    public typealias ViewModel = RoootViewViewModel
    @ObservedObject public var viewModel: ViewModel
    @State private var navigationPath: [Destination] = []
    private let navigationRouter: NavigationRouter

    public init(
        viewModel: ViewModel,
        navigationRouter: NavigationRouter
    ) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            NavigationStack(path: $navigationPath) {
                content
            }
            .navigationDestination(for: Destination.self) { newDestination in
                AnyView(navigationRouter.navigateTo(newDestination))
            }
            .onReceive(viewModel.$event) { newEvent in
                onReceiveEventHandler(newEvent)
            }
        }
    }
}

extension RootView {
    private func onReceiveEventHandler(_ newEvent: Published<Event>.Publisher.Output) {
        viewModel.receivedValues = []
        if case let .stateUpdated(state) = newEvent {
            if navigationPath.contains(state.toDestination()) {
                viewModel.isActive = true
                viewModel.receivedValues = []
                navigationPath = []
                return
            }

            viewModel.isActive = false
            navigationPath.append(state.toDestination())
        }
    }
}

public class RoootViewViewModel: BaseEventListenerViewModel {
    override public var title: String { "Event Testing App" }
    override public var action: Action { .passIntro }

    public var isActive: Bool = true

    public override func registerEvent(_ event: Event) {
        if isActive {
            self.event = event
            receivedValues.append(event)
        }
        else {
            receivedValues = []
            self.event = event
        }
    }

    override public func unregisterActive() {
    }

}

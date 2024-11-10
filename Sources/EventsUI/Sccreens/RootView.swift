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

    public init(viewModel: ViewModel, navigationRouter: NavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            NavigationStack(path: $navigationPath) {
                navigationContent
            }
            .navigationDestination(for: Destination.self) { newDestination in
                AnyView(navigationRouter.navigateTo(newDestination))
            }
            .onReceive(viewModel.$event) { newEvent in
                onReceiveEventHandler(newEvent)
            }
        }
        .onDisappear {
            viewModel.unregisterActive()
        }
    }
}

extension RootView {
    var navigationContent: some View {
        content
        .padding()
    }
}

private extension RootView {
    func onReceiveEventHandler(_ newEvent: Published<Event>.Publisher.Output) {
        if case let .stateUpdated(state) = newEvent {
            if navigationPath.contains(state.toDestination()) {
                navigationPath = []
                return
            }

            navigationPath.append(state.toDestination())
        }
    }
}

public class RoootViewViewModel: BaseEventListenerViewModel {
    override public var title: String { "Event Testing App" }
    override public var action: Action { .passIntro }
    
    override public func unregisterActive() {
    }
}

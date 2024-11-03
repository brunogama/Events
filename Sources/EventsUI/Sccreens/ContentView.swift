//
//  ContentView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct ContentView: EventObservableViewProtocol {
    public let viweId = "ContentView"
    public typealias ViewModel = ContentViewViewModel
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
                NavigationContent()
            }
            .navigationDestination(for: Destination.self) { destination in
                AnyView(navigationRouter.navigateTo(destination))
            }
            .onReceive(viewModel.$receivedValue) { newEvent in
                onReceiveEventHandler(newEvent)
            }
        }.onAppear {
            viewModel.registerActiveView(viewId)
        }.onDisappear {
            viewModel.unregisterView(viewId)
        }
    }
}

extension ContentView {
    fileprivate func NavigationContent() -> some View {
        VStack {
            Header()
            EventListView(
                events: $viewModel.receivedValues
            )
            Spacer()
            StateFullButton()
        }
        .padding()
    }
}

extension ContentView {
    fileprivate func onReceiveEventHandler(_ newEvent: Published<Event>.Publisher.Output) {
        if case let .stateUpdated(state) = newEvent {
            if navigationPath.contains(state.toDestination()) {
                navigationPath = []
                return
            }
            navigationPath.append(state.toDestination())
        }
    }
}

public class ContentViewViewModel: EventConsumerBaseViewModel {
    override public var title: String { "Event Testing App" }
    override public var action: Action { .passIntro }

    public func unbind() {
    }
}

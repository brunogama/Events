//
//  ContentView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import SwiftUI

struct ContentView: EventObservableViewProtocol {
    typealias ViewModel = ContentViewViewModel
    @ObservedObject var viewModel: ViewModel
    
    @State private var navigationPath: [Destination] = []
    private let navigationRouter: NavigationRouter
    
    init(viewModel: ViewModel, navigationRouter: NavigationRouter) {
        self.viewModel = viewModel
        self.navigationRouter = navigationRouter
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            NavigationStack(path: $navigationPath) {
                NavigationContent()
            }.navigationDestination(for: Destination.self) { destination in
                AnyView(navigationRouter.navigateTo(destination))
            }.onReceive(viewModel.$receivedValue) { newEvent in
                onReceiveEventHandler(newEvent)
            }
        }
    }
}

private extension ContentView {
    func NavigationContent() -> some View {
        VStack {
            Header()
            EventListView(
                events: $viewModel.receivedValues
            )
            Spacer()
            StateFullButton()
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
        .onDisappear {
            viewModel.viewDidDisappear()
        }.padding()
    }
}

private extension ContentView {
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
class ContentViewViewModel: EventConsumerBaseViewModel {
    override var title: String { "Event Testing App" }
    override var action: Action { .passIntro }
    
    func unbind() {
    }
}

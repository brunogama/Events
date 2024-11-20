//
//  ContentView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public class NavigationObservableDestination: ObservableObject {
    @Published public var state: RegisterState = .none
}

public struct RootView: View {

    @State private var navigationPath: [Destination] = []
    private let navigationRouter: NavigationRouter
    @ObservedObject public var navigationHandler = NavigationObservableDestination()

    public init(
        navigationRouter: NavigationRouter
    ) {
        self.navigationRouter = navigationRouter
    }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            AnyView(navigationRouter.navigateTo(.intro, navigationObservableDestination: navigationHandler))
            .navigationDestination(for: Destination.self) { newDestination in
                AnyView(navigationRouter.navigateTo(newDestination, navigationObservableDestination: navigationHandler))
            }
        }
        .onReceive(navigationHandler.$state) { state in
            if case .none = state {
                return
            }
        
            let destination = state.toDestination()
            if navigationPath.count(where: { $0 == .onboarding }) > 1 {
                navigationPath = []
            } else {
                navigationPath.append(destination)
            }
        }
        
    }
}

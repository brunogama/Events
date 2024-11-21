//
//  ContentView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct RootView: View {
    @State private var navigationPath: [Destination] = []
    private let navigationRouter: NavigationRouter
    @State private var introViewId = UUID()
    @StateObject private var navigationHandler = NavigationObservableDestination()

    public init(navigationRouter: NavigationRouter) {
        self.navigationRouter = navigationRouter
    }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            IntroViewContainer(
                navigationRouter: navigationRouter,
                navigationHandler: navigationHandler
            )
            .id(introViewId)
            .navigationDestination(for: Destination.self) { destination in
                DestinationViewContainer(
                    destination: destination,
                    navigationRouter: navigationRouter,
                    navigationHandler: navigationHandler
                )
            }
        }
        .onChange(of: navigationHandler.state) { newState in
            handleNavigationStateChange(newState)
        }
    }

    private func handleNavigationStateChange(_ state: RegisterState) {
        switch state {
        case .none:
            return
        default:
            let destination = state.toDestination()
            handleNavigation(to: destination)
        }
    }

    private func handleNavigation(to destination: Destination) {
        if destination == .onboarding && navigationPath.contains(.onboarding) {
            navigationPath.removeAll()
            introViewId = UUID()
        }
        else {
            navigationPath.append(destination)
        }
    }
}

private struct IntroViewContainer: View {
    let navigationRouter: NavigationRouter
    let navigationHandler: NavigationObservableDestination

    var body: some View {
        AnyView(
            navigationRouter.navigateTo(
                .intro,
                navigationObservableDestination: navigationHandler
            )
        )
    }
}

private struct DestinationViewContainer: View {
    let destination: Destination
    let navigationRouter: NavigationRouter
    let navigationHandler: NavigationObservableDestination

    var body: some View {
        AnyView(
            navigationRouter.navigateTo(
                destination,
                navigationObservableDestination: navigationHandler
            )
        )
    }
}

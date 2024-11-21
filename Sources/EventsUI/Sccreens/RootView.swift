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
    @State private var showBottomSheet = false
    @State private var currentState: RegisterState?
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
        .sheet(
            isPresented: $showBottomSheet,
            onDismiss: {
                showBottomSheet = false
                navigationHandler.error = nil
            }
        ) {
            if let error = navigationHandler.error {
                BottomSheetView(error: error)
                    .presentationDetents([.medium])
            }
        }
        .onChange(of: navigationHandler.state) { newState in
            handleNavigationStateChange(newState)
        }
        .onChange(of: navigationHandler.error) { _ in
            if let _ = navigationHandler.error {
                showBottomSheet = true
            }
        }
    }

    private func handleNavigationStateChange(_ state: RegisterState) {
        switch state {
        case .none:
            return
        default:
            let destination = state.toDestination()
            if destination == .none {
                currentState = state
                showBottomSheet = true
            }
            else {
                handleNavigation(to: destination)
            }
        }
    }

    private func handleNavigation(to destination: Destination) {
        if destination == .onboarding && navigationPath.contains(.onboarding) {
            navigationPath.removeAll()
            navigationHandler.state = .none
            introViewId = UUID()
        }
        else {
            Task {
                await Task.delayFor(for: 0.333)
                navigationPath.append(destination)
            }
        }
    }
}

struct BottomSheetView: View {
    let error: Error
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 42))
                .foregroundColor(.red)
            Text(error.localizedDescription)
                .font(.headline)
                .padding()
            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Close")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 42, alignment: .center)
            }

            Color.clear.padding()
        }
        .padding()
    }
}

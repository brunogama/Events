//
//  EventObservableViewProtocol 2.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

protocol EventObservableViewProtocol: HasViewModelEventConsumerProtocol, IdentifiableView {
}

extension EventObservableViewProtocol {

    @MainActor public func Content() -> some View {
        VStack {
            Header()
            EventList()
            Spacer()
            StateFullButton()
        }
    }

    @MainActor public func EventList() -> some View {
        EventListView(
            events: Binding<[Event]>(
                get: { viewModel.receivedValues },
                set: { _ in }
            )
        )
    }

    @MainActor public func Header() -> some View {
        VStack {
            Image(systemName: viewModel.receivedValue.icon)
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text(viewModel.title)
                .titleStyle(with: viewModel.title)
        }
    }

    @MainActor public func StateFullButton() -> some View {
        LoadingButton(
            title: viewModel.title,
            isLoading: Binding<Bool>(
                get: { viewModel.isProcessing },
                set: { _ in }
            )
        ) {
            viewModel.buttonTap()
        }
    }
}

extension DoneView: EventObservableViewProtocol {
    public typealias ViewModel = DoneViewModel
}

extension IntroView: EventObservableViewProtocol {}
extension LivenessView: EventObservableViewProtocol {}
extension OnboardingView: EventObservableViewProtocol {}
extension RemoveDevicesView: EventObservableViewProtocol {}
extension SMSView: EventObservableViewProtocol {}
extension EmailView: EventObservableViewProtocol {}

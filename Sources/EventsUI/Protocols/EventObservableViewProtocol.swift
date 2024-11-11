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

    var content: some View {
        VStack {
            Image(systemName: viewModel.event.icon)
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text(viewModel.title)
                .titleStyle(with: viewModel.title)

            EventListView(
                events: .constant(viewModel.receivedValues)
            )

            Spacer()

            LoadingButton(
                title: viewModel.title,
                isLoading: .constant(viewModel.event.isProcessing)
            ) {
                viewModel.buttonTap()
            }
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

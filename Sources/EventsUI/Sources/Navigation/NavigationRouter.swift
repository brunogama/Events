//
//  NavigationRouter.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import SwiftUI
import EventsDomain
import EventsCommons


public final class NavigationRouter {
    private let eventSender: EventSender
    
    public init(eventSender: EventSender) {
        self.eventSender = eventSender
    }
    
    @MainActor
    public func navigateTo(
        _ destination: Destination
    ) -> any View {
        switch destination {
        case .intro:
            let viewModel = IntroViewModel(emitter: eventSender)
            return IntroView(viewModel: viewModel)
        case .onboarding:
            let viewModel = OnboardingViewModel(emitter: eventSender)
            return OnboardingView(viewModel: viewModel)
        case .done:
            let viewModel = DoneViewModel(emitter: eventSender)
            return DoneView(viewModel: viewModel)
        case .removeDevices:
            let viewModel = RemoveDevicesViewModel(emitter: eventSender)
            return RemoveDevicesView(viewModel: viewModel)
        case .liveness:
            let viewModel = LivenessViewModel(emitter: eventSender)
            return LivenessView(viewModel: viewModel)
        case .sms:
            let viewModel = SMSViewModel(emitter: eventSender)
            return SMSView(viewModel: viewModel)
        case .email:
            let viewModel = EmailViewModel(emitter: eventSender)
            return EmailView(viewModel: viewModel)
        case .none:
            return EmptyView()
        }
    }
}

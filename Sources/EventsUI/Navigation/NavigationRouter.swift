//
//  NavigationRouter.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public final class NavigationRouter {
    private let eventBroadcaster: EventBroadCoaster

    public init(eventBroadcaster: EventBroadCoaster) {
        self.eventBroadcaster = eventBroadcaster
    }

    @MainActor
    public func navigateTo(
        _ destination: Destination
    ) -> any View {
        switch destination {
        case .intro:
            let viewModel = IntroViewModel(eventBroadcaster: eventBroadcaster)
            return IntroView(viewModel: viewModel)
        case .onboarding:
            let viewModel = OnboardingViewModel(eventBroadcaster: eventBroadcaster)
            return OnboardingView(viewModel: viewModel)
        case .done:
            let viewModel = DoneViewModel(eventBroadcaster: eventBroadcaster)
            return DoneView(viewModel: viewModel)
        case .removeDevices:
            let viewModel = RemoveDevicesViewModel(eventBroadcaster: eventBroadcaster)
            return RemoveDevicesView(viewModel: viewModel)
        case .liveness:
            let viewModel = LivenessViewModel(eventBroadcaster: eventBroadcaster)
            return LivenessView(viewModel: viewModel)
        case .sms:
            let viewModel = SMSViewModel(eventBroadcaster: eventBroadcaster)
            return SMSView(viewModel: viewModel)
        case .email:
            let viewModel = EmailViewModel(eventBroadcaster: eventBroadcaster)
            return EmailView(viewModel: viewModel)
        case .none:
            return EmptyView()
        }
    }
}

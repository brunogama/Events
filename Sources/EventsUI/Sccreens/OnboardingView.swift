//
//  OnboardingView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct OnboardingView: View {
    @StateObject public var viewModel: OnboardingViewModel

    public var body: some View {
        EventConsumerView(viewModel: viewModel)
    }
}

public class OnboardingViewModel: BaseEventListenerViewModel {
    override public var action: Action { .passOnboarding }
    override public var title: String { "OnboardingView" }
    override public var image: String { "person.crop.circle.badge.checkmark" }
    public override var state: StateFlags { .onboarding }
}

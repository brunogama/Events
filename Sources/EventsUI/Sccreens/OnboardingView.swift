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
    @State private var currentDestination: Destination? = nil

    public var body: some View {
        Content()
            .onAppear {
                viewModel.isBeingShown = true
            }
            .onDisappear {
                viewModel.isBeingShown = false
                viewModel.unbind()
            }
            .padding()
    }
}

public class OnboardingViewModel: EventConsumerBaseViewModel {
    override public var action: Action { .passOnboarding }
    override public var title: String { "OnboardingView" }
    override public var image: String { "person.crop.circle.badge.checkmark" }
    public var renderInputTextField: Bool { false }
}

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

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    @State private var currentDestination: Destination? = nil

    var body: some View {
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

class OnboardingViewModel: EventConsumerBaseViewModel {
    override var action: Action { .passOnboarding }
    override var title: String { "OnboardingView" }
    override var image: String { "person.crop.circle.badge.checkmark" }
    var renderInputTextField: Bool { false }
}

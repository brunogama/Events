//
//  OnboardingView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    @State private var currentDestination: Destination? = nil

    var body: some View {
        Content()
        .onAppear {
            viewModel.isBeingShown = true
        }.onDisappear {
            viewModel.isBeingShown = false
            viewModel.unbind()
        }.padding()
    }
}

class OnboardingViewModel: IntroViewModel {
    override var action: Action { .passOnboarding }
    override var title: String { "OnboardingView" }
    override var image: String { "person.crop.circle.badge.checkmark" }

    override func receive(_ value: Event) {
        print("OnboardingViewModel received: \(value)")
    }
}
    

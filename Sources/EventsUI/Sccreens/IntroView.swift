//
//  IntroView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct IntroView: View {
    @StateObject public var viewModel: IntroViewModel
    @State private var currentDestination: Destination? = nil

    public init(viewModel: IntroViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

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

public class IntroViewModel: EventConsumerBaseViewModel {
    public override var action: Action { .passIntro }

    public override var title: String { "IntroView" }

    public override var image: String { "sparkles" }

    public func receive(_ value: Event) {
        print("\(String(describing: type(of: self))) received: \(String(describing: value))")
    }
}
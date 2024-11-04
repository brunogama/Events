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
    @MainActor @StateObject public var viewModel: IntroViewModel
    @MainActor @State private var currentDestination: Destination? = nil

    @MainActor public init(viewModel: IntroViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    @MainActor public var body: some View {
        Content()
            .onAppear {
                viewModel.registerActiveView(viewId)
            }
            .onDisappear {
                viewModel.unregisterView(viewId)
            }
            .padding()
    }
}

public class IntroViewModel: EventConsumerBaseViewModel {
    public override var action: Action { .passIntro }

    public override var title: String { "IntroView" }

    public override var image: String { "sparkles" }

    @MainActor public func receive(_ value: Event) {
        print("\(String(describing: type(of: self))) received: \(String(describing: value))")
    }
}

//
//  LivenessView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct LivenessView: View {
    @MainActor @StateObject public var viewModel: LivenessViewModel
    @MainActor @State private var currentDestination: Destination? = nil

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

public class LivenessViewModel: EventConsumerBaseViewModel {
    override public var action: Action { .starLiveness }
    override public var title: String { "LivenessView" }
    override public var image: String { "eye.fill" }
}

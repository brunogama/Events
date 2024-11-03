//
//  LivenessView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI
import Combine

struct LivenessView: View {
    @StateObject var viewModel: LivenessViewModel
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

class LivenessViewModel: EventConsumerBaseViewModel {
    override var action: Action { .starLiveness }
    override var title: String { "LivenessView" }
    override var image: String { "eye.fill" }
}

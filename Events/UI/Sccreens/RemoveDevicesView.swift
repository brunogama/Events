//
//  RemoveDevicesView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI
import Combine

struct RemoveDevicesView: View {
    @StateObject var viewModel: RemoveDevicesViewModel
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

class RemoveDevicesViewModel: EventConsumerBaseViewModel {
    override var action: Action { .removeDevices(.mock()) }
    override var title: String { "RemoveDevicesView" }
    override var image: String { "xmark.circle.fill" }
}
    

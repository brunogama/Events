//
//  RemoveDevicesView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct RemoveDevicesView: View {
    @MainActor @StateObject public var viewModel: RemoveDevicesViewModel
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

public class RemoveDevicesViewModel: EventConsumerBaseViewModel {
    override public var action: Action { .removeDevices(.mock()) }
    override public var title: String { "RemoveDevicesView" }
    override public var image: String { "xmark.circle.fill" }
}

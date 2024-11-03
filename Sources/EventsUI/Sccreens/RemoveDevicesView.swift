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
    @StateObject public var viewModel: RemoveDevicesViewModel
    @State private var currentDestination: Destination? = nil

    public var body: some View {
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

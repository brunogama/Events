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

    public var body: some View {
        EventConsumerView(viewModel: viewModel)
    }
}

public class RemoveDevicesViewModel: BaseEventListenerViewModel {
    override public var action: Action { .removeDevices(.mock()) }
    override public var title: String { "RemoveDevicesView" }
    override public var image: String { "xmark.circle.fill" }
    public override var state: StateFlags { .removeDevices }
}

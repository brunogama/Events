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
    @StateObject public var viewModel: LivenessViewModel

    public var body: some View {
        EventConsumerView(viewModel: viewModel)
    }
}

public class LivenessViewModel: BaseEventListenerViewModel {
    override public var action: Action { .starLiveness }
    override public var title: String { "LivenessView" }
    override public var image: String { "eye.fill" }
    public override var state: StateFlags { .liveness }
}

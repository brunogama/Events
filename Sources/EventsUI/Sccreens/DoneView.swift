//
//  DoneView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct DoneView: View {
    @StateObject public var viewModel: ViewModel

    public var body: some View {
        EventConsumerView(viewModel: viewModel)
    }
}

public class DoneViewModel: BaseEventListenerViewModel {
    override public var action: Action { .passDone }

    override public var title: String { "DoneView" }

    override public var image: String { "checkmark.circle.fill" }
}

//
//  SMSView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct SMSView: View {
    @StateObject public var viewModel: SMSViewModel
    @State private var currentDestination: Destination? = nil

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

public class SMSViewModel: EventConsumerBaseViewModel {
    override public var action: Action { .smsToken(token) }

    override public var title: String { "SMSView" }

    public var textInputCaption: String { "Type SMS Token" }

    override public var image: String { "message.fill" }

    public var renderInputTextField: Bool { true }

    @MainActor @Published public var token: String = ""
}

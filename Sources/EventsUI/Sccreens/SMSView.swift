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

    public var body: some View {
        content
            .onDisappear {
                viewModel.unregisterActive()
            }
            .padding()
    }
}

public class SMSViewModel: BaseEventListenerViewModel {
    override public var action: Action { .smsToken(token) }

    override public var title: String { "SMSView" }

    public var textInputCaption: String { "Type SMS Token" }

    override public var image: String { "message.fill" }

    public var renderInputTextField: Bool { true }

    @Published public var token: String = ""
}

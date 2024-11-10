//
//  EmailView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

@MainActor public struct EmailView: View {
    public var viewModel: EmailViewModel
    @State private var currentDestination: Destination? = nil

    @MainActor public var body: some View {
        content
            .onDisappear {
                viewModel.unregisterActive()
            }
            .padding()
    }
}

public class EmailViewModel: SMSViewModel {
    override public var action: Action { .emailToken(token) }

    override public var title: String { "EmailView" }

    override public var textInputCaption: String { "Type SMS Token" }

    override public var image: String { "envelope.fill" }
}

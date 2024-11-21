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

public struct EmailView: View {
    public var viewModel: EmailViewModel

    public var body: some View {
        EventConsumerView(viewModel: viewModel)
    }
}

public class EmailViewModel: SMSViewModel {
    override public var action: Action { .emailToken(token) }
    override public var title: String { "EmailView" }
    override public var textInputCaption: String { "Type SMS Token" }
    override public var image: String { "envelope.fill" }
    public override var state: StateFlags { .email }
}

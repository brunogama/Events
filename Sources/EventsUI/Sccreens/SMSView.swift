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

    public var body: some View {
        EventConsumerView(viewModel: viewModel)
    }
}

public class SMSViewModel: BaseEventListenerViewModel {
    override public var action: Action { .smsToken(token) }
    override public var title: String { "SMSView" }
    public var textInputCaption: String { "Type SMS Token" }
    override public var image: String { "message.fill" }
    public var renderInputTextField: Bool { true }
    public override var state: StateFlags { .sms }
    @Published public var token: String = ""
}

//
//  EmailView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI
import Combine
import EventsDomain
import EventsCommons

struct EmailView: View {
    @StateObject var viewModel: EmailViewModel
    @State private var currentDestination: Destination? = nil

    var body: some View {
        Content()
            .onAppear {
                viewModel.isBeingShown = true
            }.onDisappear {
                viewModel.isBeingShown = false
                viewModel.unbind()
            }.padding()
    }
}

class EmailViewModel: SMSViewModel {
    override var action: Action { .emailToken(token) }
    
    override var title: String { "EmailView" }
    
    override var textInputCaption: String { "Type SMS Token" }
    
    override var image: String { "envelope.fill" }
}

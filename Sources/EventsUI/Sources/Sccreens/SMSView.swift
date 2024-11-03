//
//  SMSView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI
import Combine

struct SMSView: View {
    @StateObject var viewModel: SMSViewModel
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

class SMSViewModel: EventConsumerBaseViewModel {
    override var action: Action { .smsToken(token) }
    
    override var title: String { "SMSView" }
    
    var textInputCaption: String { "Type SMS Token" }
    
    override var image: String { "message.fill" }
    
    var renderInputTextField: Bool { true }

    @Published var token: String = ""
}

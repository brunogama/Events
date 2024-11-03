//
//  IntroView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import SwiftUI
import Combine

struct IntroView: View {
    @StateObject var viewModel: IntroViewModel
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

class IntroViewModel: EventConsumerBaseViewModel {
    override var action: Action { .passIntro }
    
    override var title: String { "IntroView" }
    
    override var image: String { "sparkles" }
    
    func receive(_ value: Event) {
        print("\(String(describing: type(of: self))) received: \(String(describing: value))")
    }
}
    

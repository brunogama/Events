//
//  DoneView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//


import SwiftUI
import Combine

struct DoneView: View {
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
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

class DoneViewModel: EventConsumerBaseViewModel {
    override var action: Action { .passDone }
    
    override var title: String { "DoneView" }
    
    override var image: String { "checkmark.circle.fill" }
    
    func receive(_ value: Event) {
        print("\(String(describing: type(of: self))) received: \(String(describing: value).reversed())")
    }
}
    

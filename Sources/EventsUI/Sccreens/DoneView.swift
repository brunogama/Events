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

    public init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
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

public class DoneViewModel: EventConsumerBaseViewModel {
    override public var action: Action { .passDone }

    override public var title: String { "DoneView" }

    override public var image: String { "checkmark.circle.fill" }

    public func receive(_ value: Event) {
        print("\(String(describing: type(of: self))) received: \(String(describing: value).reversed())")
    }
}

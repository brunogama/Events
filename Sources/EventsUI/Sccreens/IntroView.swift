//
//  IntroView.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct IntroView: View {
    @StateObject public var viewModel: IntroViewModel

    public init(viewModel: IntroViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        content
            .padding()
    }
}

public class IntroViewModel: BaseEventListenerViewModel {
    public override var action: Action { .passIntro }

    public override var title: String { "IntroView" }

    public override var image: String { "sparkles" }

    @MainActor public func receive(_ value: Event) {
        print("\(String(describing: type(of: self))) received: \(String(describing: value))")
    }
}

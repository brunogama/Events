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

    public var body: some View {
        content
            .padding()
    }
}

public class IntroViewModel: BaseEventListenerViewModel {
    public override var action: Action { .passIntro }
    public override var title: String { "IntroView" }
    public override var image: String { "sparkles" }
}

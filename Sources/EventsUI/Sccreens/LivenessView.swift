//
//  LivenessView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

public struct LivenessView: View {
    @StateObject public var viewModel: LivenessViewModel

    @MainActor public var body: some View {
        content
            .padding()
    }
}

public class LivenessViewModel: BaseEventListenerViewModel {
    override public var action: Action { .starLiveness }
    override public var title: String { "LivenessView" }
    override public var image: String { "eye.fill" }
}

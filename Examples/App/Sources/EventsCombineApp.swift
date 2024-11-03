//
//  EventsCombineApp.swift
//  EventsCombine
//
//  Created by Bruno on 03/11/24.
//

import EventsCommons
import EventsDomain
import EventsServices
import EventsUI
import SwiftUI

@main
struct EventsOnCombineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewViewModel(emitter: CompositionRoot.shared.eventSender),
                navigationRouter: CompositionRoot.shared.navigationRouter
            )
        }
    }
}

struct CompositionRoot {
    static let shared = CompositionRoot()

    let eventSender: EventSender
    let navigationRouter: NavigationRouter

    init() {
        self.eventSender = EventSender()
        self.navigationRouter = NavigationRouter(eventSender: eventSender)
    }
}

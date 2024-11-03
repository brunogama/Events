//
//  EventsApp.swift
//  Events
//
//  Created by Bruno on 01/11/24.
//

import SwiftUI
import EventUI
import EventsCommons
import EventsDomain
import EventsServices

@main
struct EventsApp: App {
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

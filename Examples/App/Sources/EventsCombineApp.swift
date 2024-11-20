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
            RootView(navigationRouter: CompositionRoot.shared.navigationRouter)
        }
    }
}

struct CompositionRoot {
    static let shared = CompositionRoot()

    let eventSender: EventBroadCoaster
    let navigationRouter: NavigationRouter

    init() {
        self.eventSender = EventBroadCoaster()
        self.navigationRouter = NavigationRouter(eventBroadcaster: eventSender)
    }
}

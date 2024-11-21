//
//  IntroViewContainer.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 20/11/24.
//

import SwiftUI
import EventsDomain
import EventsCommons

struct IntroViewContainer: View {
    let navigationRouter: NavigationRouter
    let navigationHandler: NavigationObservableDestination

    var body: some View {
        AnyView(
            navigationRouter.navigateTo(
                .intro,
                navigationObservableDestination: navigationHandler
            )
        )
    }
}

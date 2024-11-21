//
//  DestinationViewContainer.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 20/11/24.
//

import SwiftUI
import EventsDomain
import EventsCommons

struct DestinationViewContainer: View {
    let destination: Destination
    let navigationRouter: NavigationRouter
    let navigationHandler: NavigationObservableDestination

    var body: some View {
        AnyView(
            navigationRouter.navigateTo(
                destination,
                navigationObservableDestination: navigationHandler
            )
        )
    }
}

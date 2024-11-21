//
//  EventListView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct EventListView: View {
    
    @Binding public var events: [Event]
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 10) {
                    ForEach(Array(events.enumerated()), id: \.offset) { _, event in
                        EventRow(event: event)
                            .transition(
                                .asymmetric(
                                    insertion: .scale(scale: 0.3)
                                        .combined(with: .opacity)
                                        .combined(with: .move(edge: .bottom)),
                                    removal: .opacity
                                )
                            )
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .onChange(of: events.count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        proxy.scrollTo(events.count - 1, anchor: .bottom)
                    }
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: events.count)
    }
}

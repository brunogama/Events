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
                rowEventStack(events, proxy)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: events.count)
    }
}

private extension EventListView {
    func eventRow(_ event: Event) -> some View {
        EventRow(event: event)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 0.5)
                        .combined(with: .opacity)
                        .combined(with: .move(edge: .bottom)),
                    removal: .opacity
                )
            )
            .padding(.horizontal)
    }
    
    func rowEventStack(_ events: [Event], _ scrollViewProxy: ScrollViewProxy) -> some View {
        VStack {
            VStack(spacing: 10) {
                ForEach(Array(events.enumerated()), id: \.offset) { _, event in
                    eventRow(event)
                }
            }
            .padding(.vertical)
            .onChange(of: events.count) { _ in
                withAnimation(.easeOut(duration: 0.5)) {
                    scrollViewProxy.scrollTo(events.count, anchor: .bottom)
                }
            }
        }
    }
}

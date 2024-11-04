//
//  EventListView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

@MainActor
public struct EventListView: View {
    @Binding public var events: [Event]
    public var body: some View {
        ScrollViewReader { @MainActor scrollViewProxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events) { @MainActor event in
                        EventRow(event: event)
                            .padding(.horizontal)
                    }

                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .padding(.vertical)
                .onAppear {
                    scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                }
                .onChange(of: events, initial: true) {
                    scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .background(Color.dynamicBackground.ignoresSafeArea())
        }
        .onAppear {
            events = []
        }
    }
}

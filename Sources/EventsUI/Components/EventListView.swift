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
    @MainActor @Binding public var events: [Event]

    public var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events) { event in
                        EventRow(event: event)
                            .padding(.horizontal)
                    }

                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .padding(.vertical)
                .onAppear {
                    DispatchQueue.main.async {
                        scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
                .onChange(of: events, initial: true) {
                    DispatchQueue.main.async {
                        scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            .background(Color.dynamicBackground.ignoresSafeArea())
        }.onAppear {
            events = []
        }
    }
}

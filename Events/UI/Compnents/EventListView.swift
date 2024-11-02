//
//  EventListView.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI

//struct EventListView: View {
//    @Binding var events: [Event]
//
//    var body: some View {
//        ScrollViewReader { scrollViewProxy in
//            ScrollView {
//                LazyVStack(spacing: 16) {
//                    ForEach(events) { event in
//                        EventRow(event: event)
//                            .padding(.horizontal)
//                    }
//
//                    Color.clear
//                        .frame(height: 1)
//                        .id("bottom")
//                }
//                .padding(.vertical)
//                .onAppear {
//                    scrollViewProxy.scrollTo("bottom", anchor: .bottom)
//                }
//                .onChange(of: events, initial: true) {
//                    scrollViewProxy.scrollTo("bottom", anchor: .bottom)
//                }
//            }
//            .background(Color.dynamicBackground.ignoresSafeArea())
//        }
//    }
//}

struct EventListView: View {
    @Binding var events: [Event]

    var body: some View {
        VStack {
            eventScrollView()
        }
    }
}

extension EventListView {
    private func eventScrollView() -> some View {
        SwiftUI.ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    eventRow(for: event, index: index)
                }
            }
            .padding(.vertical)
        }
    }
    
    private func eventRow(for event: Event, index: Int) -> some View {
        Events.EventRow(event: event)
            .padding(.horizontal)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5).delay(0.1 * Double(index))) {
                    // Animation with delay based on index
                }
            }
    }
}

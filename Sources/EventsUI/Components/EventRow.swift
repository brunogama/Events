//
//  EventRow.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct EventRow: View {
    @MainActor let event: Event
    
    init(event: Event) {
        self.event = .idle
    }

    public var body: some View {
        HStack {
            Image(systemName: event.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(event.isProcessing ? "Processing" : "Idle")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

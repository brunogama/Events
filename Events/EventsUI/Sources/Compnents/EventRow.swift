//
//  EventRow.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI

struct EventRow: View {
    let event: Event

    var body: some View {
        HStack {
            Image(systemName: event.icon) // Display the icon on the left
                .font(.title2)
                .foregroundColor(.blue) // Adjust color as needed
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

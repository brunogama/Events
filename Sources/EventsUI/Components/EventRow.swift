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
    let event: Event
    @State private var isShowing = false
    
    public init(event: Event) {
        self.event = event
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
        .offset(y: isShowing ? 0 : 50)
        .opacity(isShowing ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                isShowing = true
            }
        }
    }
}

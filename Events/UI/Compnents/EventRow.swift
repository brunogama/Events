//
//  EventRow.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

//import SwiftUI
//
//struct EventRow: View {
//    let event: Event
//
//    var body: some View {
//        HStack {
//            Image(systemName: event.icon) // Display the icon on the left
//                .font(.title2)
//                .foregroundColor(.blue) // Adjust color as needed
//                .padding(.trailing, 8)
//            
//            VStack(alignment: .leading) {
//                Text(event.name)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//                
//                Text(event.isProcessing ? "Processing" : "Idle")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//    }
//}
import SwiftUI

struct EventRow: View {
    let event: Event
    @State private var isVisible = false

    var body: some View {
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .opacity(isVisible ? 1 : 0) // Start with opacity 0
        .offset(y: isVisible ? 0 : 10) // Start with offset for upward movement
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true // Animate to full opacity and original position
            }
        }
    }
}

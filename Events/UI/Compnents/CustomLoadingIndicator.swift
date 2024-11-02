//
//  CustomLoadingIndicator.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI

struct CustomLoadingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // First Arc
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.5)]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            // Second Arc
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.cyan]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: isAnimating ? 0 : -360))
                .animation(
                    .linear(duration: 1.2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .frame(width: 50, height: 50)
        .onAppear {
            isAnimating = true
        }
    }
}

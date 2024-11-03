//
//  LoadingButton.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

//import SwiftUI
//
//struct LoadingButton: View {
//    let title: String
//    @Binding var isLoading: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: {
//            if !isLoading {
//                action()
//            }
//        }) {
//            ZStack {
//                // Invisible background text for consistent button width
//                Text(title)
//                    .font(.headline)
//                    .opacity(0)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                
//                if isLoading {
//                    CustomLoadingIndicator() // Use the custom loading indicator
//                        .frame(width: 24, height: 24)
//                } else {
//                    Text(title)
//                        .font(.headline)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                }
//            }
//        }
//        .background(isLoading ? Color.gray : Color.blue)
//        .foregroundColor(.white)
//        .cornerRadius(10)
//        .padding(.horizontal)
//        .disabled(isLoading)
//    }
//}
//
//

import SwiftUI

struct LoadingButton: View {
    typealias ButtonAction = (() -> Void)?
    
    let title: String
    @Binding var isLoading: Bool
    let action: ButtonAction
    
    init(
        title: String,
        isLoading: Binding<Bool> = .constant(false),
        action: ButtonAction = ClosureUtils.makeDefaultHandler()
    ) {
        self.title = title
        self._isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if !isLoading {
                action?()
            }
        }) {
            ZStack {
                // Invisible text to keep button width consistent
                Text(title)
                    .font(.headline)
                    .opacity(0)
                    .padding()
                    .frame(maxWidth: .infinity)
                
                if isLoading {
                    ProgressView() // Simple loading spinner
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2) // Makes spinner slightly larger
                } else {
                    Text(title)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .background(isLoading ? Color.blue.opacity(0.5) : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .disabled(isLoading)
    }
}

#if DEBUG
struct ButtonDebugWrapper<Content: View>: View {
    let content: Content
    @State private var isTapped = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .border(Color.red) // Visual boundary
            .overlay(
                Rectangle()
                    .stroke(isTapped ? Color.green : Color.clear)
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        print("Debug: Touch detected")
                        isTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isTapped = false
                        }
                    }
            )
    }
}
#endif

#Preview {
    LoadingButton(title: "Submit", isLoading: .constant(false)) {
        print("Button tapped")
    }
}

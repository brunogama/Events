//
//  LoadingButton.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import SwiftUI

public struct LoadingButton: View {
    public typealias ButtonAction = (() -> Void)?

    public let title: String
    @MainActor @Binding public var isLoading: Bool
    @MainActor public let action: ButtonAction

    @MainActor public init(
        title: String,
        isLoading: Binding<Bool> = .constant(false),
        action: ButtonAction = makeDefaultHandler()
    ) {
        self.title = title
        self._isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: {
            if !isLoading {
                action?()
            }
        }) {
            ZStack {
                Text(title)
                    .font(.headline)
                    .opacity(0)
                    .padding()
                    .frame(maxWidth: .infinity)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                }
                else {
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

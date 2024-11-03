//
//  LifecycleModifier.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct OnLoadModifier: ViewModifier {
    @State private var isInitialized = false
    public let action: () -> Void

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if !isInitialized {
                    action()
                    isInitialized = true
                }
            }
    }
}

public struct OnAppearModifier: ViewModifier {
    public let action: () -> Void

    public func body(content: Content) -> some View {
        content
            .onAppear {
                action()
            }
    }
}

public struct OnDisappearModifier: ViewModifier {
    public let action: () -> Void

    public func body(content: Content) -> some View {
        content
            .onDisappear {
                action()
            }
    }
}

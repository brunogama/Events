//
//  LifecycleModifier.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

struct OnLoadModifier: ViewModifier {
    @State private var isInitialized = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !isInitialized {
                    action()
                    isInitialized = true
                }
            }
    }
}

struct OnAppearModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                action()
            }
    }
}

struct OnDisappearModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onDisappear {
                action()
            }
    }
}

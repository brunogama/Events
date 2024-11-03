//
//  TitleStyleModifier.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct TitleStyleModifier: ViewModifier {
    public var title: String

    public func body(content: Content) -> some View {
        content
            .font(.title)
            .padding()
            .navigationTitle(title)
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}

extension View {
    public func titleStyle(with title: String) -> some View {
        self.modifier(TitleStyleModifier(title: title))
    }
}

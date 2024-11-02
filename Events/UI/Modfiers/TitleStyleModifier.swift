//
//  TitleStyleModifier.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//


import SwiftUI

struct TitleStyleModifier: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    func titleStyle(with title: String) -> some View {
        self.modifier(TitleStyleModifier(title: title))
    }
}


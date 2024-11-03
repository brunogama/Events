//
//  IdentifiableView.swift
//  Events
//
//  Created by Bruno on 03/11/24.
//

import SwiftUI

public protocol IdentifiableView: View {
    var viewId: String { get }
}

extension IdentifiableView {
    public var viewId: String {
        String(describing: type(of: self))
    }
}

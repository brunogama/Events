//
//  NavigationObservableDestination.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 20/11/24.
//

import SwiftUI
import EventsDomain

public class NavigationObservableDestination: ObservableObject {
    @Published public var state: RegisterState = .none
    @Published public var error: ValidationError?
}

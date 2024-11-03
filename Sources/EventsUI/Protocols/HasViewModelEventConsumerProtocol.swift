//
//  HasViewModelEventConsumerProtocol.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public protocol HasViewModelEventConsumerProtocol: View {
    associatedtype ViewModel: EventConsumerProtocol

    var viewModel: ViewModel { get }
}

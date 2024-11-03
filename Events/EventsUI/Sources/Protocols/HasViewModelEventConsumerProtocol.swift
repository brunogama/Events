//
//  HasViewModelEventConsumerProtocol.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import SwiftUI

protocol HasViewModelEventConsumerProtocol: View {
    associatedtype ViewModel: EventConsumerProtocol
    
    var viewModel: ViewModel { get }
}

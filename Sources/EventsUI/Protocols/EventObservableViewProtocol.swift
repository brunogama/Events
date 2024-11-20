//
//  EventObservableViewProtocol 2.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Combine
import EventsCommons
import EventsDomain
import SwiftUI

protocol EventObservableViewProtocol: HasViewModelEventConsumerProtocol, IdentifiableView {
}

extension DoneView: EventObservableViewProtocol {
    public typealias ViewModel = DoneViewModel
}

extension IntroView: EventObservableViewProtocol {}
extension LivenessView: EventObservableViewProtocol {}
extension OnboardingView: EventObservableViewProtocol {}
extension RemoveDevicesView: EventObservableViewProtocol {}
extension SMSView: EventObservableViewProtocol {}
extension EmailView: EventObservableViewProtocol {}

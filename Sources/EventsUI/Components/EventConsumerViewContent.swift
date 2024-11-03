//
//  EventConsumerViewContent.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import EventsCommons
import EventsDomain
import SwiftUI

public struct EventConsumerViewContent: View {
    @ObservedObject public var viewModel: EventConsumerBaseViewModel

    public var body: some View {
        EmptyView()
        //        VStack {
        //            Header()
        //
        //            EventListView(events: $viewModel.receivedValues)
        //
        //            Rectangle()
        //                .fill(Color.dynamicBackground)
        //                 .frame(height: 1)
        //                 .padding(.vertical, padding)
        //
        //            LoadingButton(
        //                action: viewModel.action,
        //                title: viewModel.title
        //            ) {
        //                viewModel.buttonTap()
        //            }
        //        }
    }
}

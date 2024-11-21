//
//  EventConsumerView.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 20/11/24.
//

import SwiftUI
import EventsDomain
import EventsCommons

public struct EventConsumerView: View {
    @ObservedObject var viewModel: BaseEventListenerViewModel
    
    public var body: some View {
        VStack {
            Image(systemName: viewModel.image)
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text(viewModel.title)
                .titleStyle(with: viewModel.title)

            EventListView(
                events: .constant(viewModel.receivedValues)
            )

            Spacer()

            LoadingButton(
                title: viewModel.title,
                isLoading: .constant(viewModel.event.isProcessing)
            ) {
                viewModel.buttonTap()
            }
        }.navigationTitle(viewModel.title)
    }
}


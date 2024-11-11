//
//  SubscriptionToken.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 10/11/24.
//

import Combine

public class SubscriptionToken {
    private var cancellable: AnyCancellable?

    deinit {
        cancel()
    }

    public func store(_ cancellable: AnyCancellable) {
        self.cancellable?.cancel()
        self.cancellable = cancellable
    }

    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}

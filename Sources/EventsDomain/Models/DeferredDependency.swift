//
//  DeferredDependency.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 20/11/24.
//

public enum DeferredDependency: Equatable {
    case all(StateFlags)
    case any(StateFlags)
    case either(StateFlags, StateFlags)
    case none
}

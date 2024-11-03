//
//  ReflectableDescription.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

public protocol ReflectableDescription {
    var instanceDescription: String { get }
}

extension ReflectableDescription {
    public var instanceDescription: String {
        ReflectableInstanceDescription(self).description
    }
}

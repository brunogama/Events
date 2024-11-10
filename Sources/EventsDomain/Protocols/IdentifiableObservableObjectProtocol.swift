//
//  IdentifiableObservableObjectProtocol.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 10/11/24.
//

import SwiftUI

public protocol IdentifiableObservableObjectProtocol: AnyObject, ObservableObject {
    var objectId: String { get }
}

extension IdentifiableObservableObjectProtocol {
    public var objectId: String {
        String(ObjectIdentifier(self).hashValue)
    }
}

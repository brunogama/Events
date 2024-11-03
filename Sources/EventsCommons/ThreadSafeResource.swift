//
//  ThreadSafeResource.swift
//  EnventConsumerSimulation
//
//  Created by Bruno on 03/11/24.
//

import Foundation

public class ThreadSafeResource<T> {
    private let lock = NSLock()
    private var resource: T
    
    public init(initialResource: T) {
        self.resource = initialResource
    }
    
    public func getResource() -> T {
        lock.lock()
        defer { lock.unlock() }
        return resource
    }
    
    public func setResource(_ newValue: T) {
        lock.lock()
        defer { lock.unlock() }
        resource = newValue
    }
    
    public func updateResource(_ update: (inout T) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        update(&resource)
    }
}

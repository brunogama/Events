//
//  ClosureDecorator.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Foundation

/// Usage
/// This type receives as closures as parameters
/// By using this decorator you can add custom behaviour
/// to closures.
/// Like this sample:
/// When the closures of this type execute it will be wrapped
/// in the closure created by the decorator.
/// Example:
///  ```
///struct EquatableTypeHandler {
///    let canHandle: (Any, Any) -> Bool
///    let areEqual: (Any, Any) -> Bool
///
///    init(
///        canHandle: @escaping (Any, Any) -> Bool,
///        areEqual: @escaping (Any, Any) -> Bool
///    ) {
///        self.canHandle = closureDecorator(canHandle) { closure, a, b in
///            print("🚨 Checking if can handle ")
///            // Perform more stuff
///            return closure(a, b)
///        }
///
///        self.areEqual = closureDecorator(canHandle) { closure, a, b in
///            print("🚨 Checking if are equal ")
///            // Perform more stuff
///            return closure(a, b)
///        }
///    }
///}
///  ```

public func closureDecorator<each T, R>(
    _ closure: @escaping (repeat each T) -> R,
    with decorator: @escaping (@escaping (repeat each T) -> R, repeat each T) -> R
) -> (repeat each T) -> R {
    { (args: repeat each T) in
        decorator(closure, repeat each args)
    }
}

/// This is the default handler for the decorator
/// If the closure is not set, this will be called
/// and the app will crash.
public func makeDefaultHandler<each T, R>() -> (repeat each T) -> R {
    return { (_ arg: repeat each T) in
        assertionFailure("Closure is set to default. Please set a custom closure.")
        abort()
    }
}

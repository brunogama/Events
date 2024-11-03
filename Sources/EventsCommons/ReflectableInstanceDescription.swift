//
//  ReflectableInstanceDescription.swift
//  Events
//
//  Created by Bruno on 02/11/24.
//

import Foundation

public struct ReflectableInstanceDescription: CustomStringConvertible, Hashable, Equatable {
    public let description: String

    public init(_ value: Any) {
        let builder = ValueDescriptionBuilder.shared
        self.description = builder.buildDescription(of: value)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: type(of: self)))
        hasher.combine(description)
    }

    public static func == (lhs: ReflectableInstanceDescription, rhs: ReflectableInstanceDescription) -> Bool {
        lhs.description == rhs.description
    }
}

// MARK: - ValueDescriptionBuilder and Handlers

private protocol ValueDescriptionHandler: Sendable {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool
    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String
}

package final class ValueDescriptionBuilder: Sendable {
    static let shared = ValueDescriptionBuilder()

    fileprivate let handlers: [ValueDescriptionHandler] = [
        OptionalHandler(),
        CollectionHandler(),
        DictionaryHandler(),
        EnumHandler(),
        StructClassHandler(),
        DefaultHandler(),
    ]

    let queue = DispatchQueue(label: "ValueDescriptionBuilder")

    private init() {}

    func buildDescription(of value: Any) -> String {
        queue.sync {
            let mirror = Mirror(reflecting: value)
            for handler in handlers {
                if handler.canHandle(mirror.displayStyle) {
                    return handler.handle(value, builder: self)
                }
            }
            return "\(value)"
        }
    }
}

// MARK: - Handlers

private struct OptionalHandler: ValueDescriptionHandler {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool {
        displayStyle == .optional
    }

    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String {
        let mirror = Mirror(reflecting: value)
        if let child = mirror.children.first {
            return builder.buildDescription(of: child.value)
        }
        else {
            return "nil"
        }
    }
}

private struct CollectionHandler: ValueDescriptionHandler {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool {
        displayStyle == .collection || displayStyle == .set
    }

    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String {
        let mirror = Mirror(reflecting: value)
        let elements = mirror.children.map { builder.buildDescription(of: $0.value) }
        return "[\(elements.joined(separator: ", "))]"
    }
}

private struct DictionaryHandler: ValueDescriptionHandler {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool {
        displayStyle == .dictionary
    }

    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String {
        let mirror = Mirror(reflecting: value)
        let elements = mirror.children.compactMap { child -> String? in
            if let pair = child.value as? (key: AnyHashable, value: Any) {
                let keyDesc = builder.buildDescription(of: pair.key)
                let valueDesc = builder.buildDescription(of: pair.value)
                return "\(keyDesc): \(valueDesc)"
            }
            return nil
        }
        return "{\(elements.joined(separator: ", "))}"
    }
}

private struct EnumHandler: ValueDescriptionHandler {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool {
        displayStyle == .enum
    }

    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String {
        let mirror = Mirror(reflecting: value)
        if let caseName = mirror.children.first?.label {
            var result = ".\(caseName)"
            if let associatedValue = mirror.children.first?.value {
                let associatedDesc = builder.buildDescription(of: associatedValue)
                result += "(\(associatedDesc))"
            }
            return result
        }
        else {
            return "\(value)"
        }
    }
}

private struct StructClassHandler: ValueDescriptionHandler {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool {
        displayStyle == .struct || displayStyle == .class
    }

    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String {
        let mirror = Mirror(reflecting: value)
        let elements = mirror.children.compactMap { child -> String? in
            if let label = child.label {
                let valueDesc = builder.buildDescription(of: child.value)
                return "\(label): \(valueDesc)"
            }
            return nil
        }
        return "{\(elements.joined(separator: ", "))}"
    }
}

private struct DefaultHandler: ValueDescriptionHandler {
    func canHandle(_ displayStyle: Mirror.DisplayStyle?) -> Bool {
        true
    }

    func handle(_ value: Any, builder: ValueDescriptionBuilder) -> String {
        "\(value)"
    }
}

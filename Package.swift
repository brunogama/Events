// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swifft-lint:disable all
import PackageDescription

enum Products: String, CaseIterable {
    static var productNam: String { "EventsPackage" }

    case commons = "EventsCommons"
    case domain = "EventsDomain"
    case services = "EventsServices"
    case ui = "EventsUI"
    case example = "Example"

    var path: String {
        if case .example = self {
            return "Example/\(self.rawValue)/Sources"
        }
        return "Sources/\(self.rawValue)/Sources"
    }

    var dependencies: [Products] {
        switch self {
        case .example:
            [.ui, .domain, .services, .commons]
        case .commons:
            []
        case .ui:
            [.domain, .commons]
        case .domain:
            [.commons, .services]
        case .services:
            [.commons]
        }
    }

    static var platforms: [SupportedPlatform] {
        [.iOS(.v17), .macOS(.v10_14)]
    }

    var libraryTargets: [String] {
        let libraryTarget: [Products] =
            switch self {
            case .example:
                [.ui, .domain, .services, .commons]
            case .commons:
                [.commons]
            case .domain:
                [.domain, .commons]
            case .services:
                [.domain, .commons]
            case .ui:
                [.domain, .commons]
            }
        return libraryTarget.compactMap { $0.rawValue }
    }

    static var products: [Product] {
        Self.allCases
            .compactMap {
                if case .example = $0 {
                    return .executable(
                        name: $0.rawValue,
                        targets: $0.libraryTargets
                    ),
                }
                return .library(
                    name: $0.rawValue,
                    type: .static,
                    targets: $0.libraryTargets
                )
            }
    }

    static var targets: [Target] {
        Self.allCases.compactMap {
            let dependencies: [Target.Dependency] = $0
                .dependencies
                .compactMap {
                    .target(
                        name: $0.rawValue,
                        condition:
                            .when(platforms: [.iOS])
                    )
                }
            return .target(
                name: $0.rawValue,
                dependencies: dependencies,
                path: $0.path
            )
        }
    }
}

let package = Package(
    name: Products.productNam,
    platforms: Products.platforms,
    products: Products.products,
    targets: Products.targets
)
// swifft-lint:enable all

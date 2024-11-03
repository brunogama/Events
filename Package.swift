// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Events",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "EventsCommons",
            type: .static,
            targets: ["EventsCommons"]
        ),
        .library(
            name: "EventsDomain",
            type: .static,
            targets: ["EventsDomain"]
        ),
        .library(
            name: "EventsServices",
            targets: ["EventsServices"]
        ),
        .library(
            name: "EventsUI",
            type: .static,
            targets: ["EventsUI"]
        )
    ],
    targets: [
        .target(
            name: "EventsCommons",
            path: "Sources/EventsCommons"
        ),
        .target(
            name: "EventsDomain",
            dependencies: [
                .target(name: "EventsCommons"),
            ],
            path: "Sources/EventsDomain"
        ),
        .target(
            name: "EventsServices",
            dependencies: [
                .target(name: "EventsCommons"),
                .target(name: "EventsDomain")
            ],
            path: "Sources/EventsServices"
        ),
        .target(
            name: "EventsUI",
            dependencies: [
                .target(name: "EventsCommons"),
                .target(name: "EventsDomain")
            ],
            path: "Sources/EventsUI"
        ),
    ],
    swiftLanguageVersions: [.v5]
) // Only one closing parenthesis here

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Events",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "EventsCommons",
            targets: ["EventsCommons"]
        ),
        .library(
            name: "EventsDomain",
            targets: ["EventsDomain"]
        ),
        .library(
            name: "EventsServices",
            targets: ["EventsServices"]
        ),
        .library(
            name: "EventsUI",
            targets: ["EventsUI"]
        )
    ],
    targets: [
        .target(
            name: "EventsCommons",
            dependencies: [],
            path: "Sources/EventsCommons"
        ),
        .target(
            name: "EventsDomain",
            dependencies: [
                .target(name: "EventsCommons"),
                .target(name: "EventsServices")
            ],
            path: "Sources/EventsDomain"
        ),
        .target(
            name: "EventsServices",
            dependencies: [
                .target(name: "EventsCommons")
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
        )
    ]
) // Only one closing parenthesis here
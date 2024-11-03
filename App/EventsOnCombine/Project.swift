// swift-tools-version: 5.9

import MyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

/*
                +-------------+
                |             |
                |     App     | Contains EventsValidationCombine App target and EventsValidationCombine unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project: Project = .app(
    name: "EventsValidationCombine",
    destinations: .iOS,
    additionalTargets: [],
    dependencies: [
        .project(target: "", path: .relativeToManifest("../"), product: .library)
    ]
)

// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "__REPO__",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "__MODULE__", targets: ["__MODULE__"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "__MODULE__",
            dependencies: [],
        ),
        .testTarget(
            name: "__MODULE__Tests",
            dependencies: ["__MODULE__"],
            resources: [.copy("Fixtures")],
        ),
    ]
)

// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Core",
            dependencies: [],
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"],
        ),
    ]
)

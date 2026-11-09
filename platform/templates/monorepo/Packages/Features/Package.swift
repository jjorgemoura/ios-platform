// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Features", targets: ["Features"])
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                .product(name: "Core", package: "Core")
            ],
        ),
        .testTarget(
            name: "FeaturesTests",
            dependencies: ["Features"],
        ),
    ]
)

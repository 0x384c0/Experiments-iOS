// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "FeaturesHost",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "FeaturesHostPresentation",
            targets: ["FeaturesHostPresentation"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FeaturesHostPresentation",
            dependencies: [],
            path: "Sources/Presentation"),
    ]
)

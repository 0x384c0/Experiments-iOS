// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "FeaturesHost",
    platforms: [ .iOS(.v14), ],
    products: [
        .library(
            name: "FeaturesHostPresentation",
            targets: ["FeaturesHostPresentation"]),
    ],
    dependencies: [
        .package(path: "../RedditPosts"),
    ],
    targets: [
        .target(
            name: "FeaturesHostPresentation",
            dependencies: [
                .product(name: "RedditPostsPresentation", package: "RedditPosts"),
            ],
            path: "Sources/Presentation"
        ),
    ]
)

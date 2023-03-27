// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "RedditPosts",
    platforms: [ .iOS(.v14), ],
    products: [
        .library(
            name: "RedditPostsPresentation",
            targets: ["RedditPostsPresentation"]),
    ],
    targets: [
        .target(
            name: "RedditPostsPresentation",
            dependencies: [],
            path: "Sources/Presentation"
        ),
    ]
)

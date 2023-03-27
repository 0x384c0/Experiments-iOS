// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "RedditPosts",
    platforms: [ .iOS(.v14), ],
    products: [
        .library(
            name: "RedditPostsPresentation",
            targets: ["RedditPostsPresentation"]
        ),
        .library(
            name: "RedditPostsDomain",
            targets: ["RedditPostsDomain"]
        ),
        .library(
            name: "RedditPostsData",
            targets: ["RedditPostsData"]
        ),
    ],
    dependencies: [
        .package(path: "../../Common"),
    ],
    targets: [
        .target(
            name: "RedditPostsPresentation",
            dependencies: [
                .target(name: "RedditPostsDomain"),
                "Common",
            ],
            path: "Sources/Presentation"
        ),
        .target(
            name: "RedditPostsDomain",
            dependencies: [
                "Common",
            ],
            path: "Sources/Domain"
        ),
        .target(
            name: "RedditPostsData",
            dependencies: [
                .target(name: "RedditPostsDomain"),
                "Common",
            ],
            path: "Sources/Data"
        ),
    ]
)

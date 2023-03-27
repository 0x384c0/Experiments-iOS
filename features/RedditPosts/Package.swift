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
    targets: [
        .target(
            name: "RedditPostsPresentation",
            dependencies: [
                .target(name: "RedditPostsDomain"),
            ],
            path: "Sources/Presentation"
        ),
        .target(
            name: "RedditPostsDomain",
            dependencies: [],
            path: "Sources/Domain"
        ),
        .target(
            name: "RedditPostsData",
            dependencies: [],
            path: "Sources/Data"
        ),
    ]
)

//
// Created on: 14/9/23

import Foundation

public struct PostModel {
    public init(
        permalink: String?,
        author: String?,
        category: String?,
        icon: URL?,
        title: String?,
        comments: [PostModel]?
    ) {
        self.permalink = permalink
        self.author = author
        self.category = category
        self.icon = icon
        self.title = title
        self.comments = comments
    }

    let permalink: String?
    let author: String?
    let category: String?
    let icon: URL?
    let title: String?
    let comments: [PostModel]?
}

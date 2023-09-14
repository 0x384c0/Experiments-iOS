//
// Created on: 14/9/23

import Foundation
import Common
import RedditPostsDomain

class RedditPostsResponseDTOMapper {
    typealias IN = RedditPostsResponseDTO
    typealias OUT = [PostModel]

    func map(input: RedditPostsResponseDTO) -> [PostModel] {
        input.data?.children?.map {
            PostModel(
                permalink: $0.data?.permalink,
                author: $0.data?.author,
                category: $0.data?.subreddit,
                icon: $0.data?.thumbnail != nil ? URL(string: $0.data!.thumbnail!) : nil,
                title: $0.data?.title,
                comments: nil
            )
        } ?? []
    }
}

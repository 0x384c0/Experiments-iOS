//
// Created on: 14/9/23

import Common
import RedditPostsDomain
import Foundation

class RedditPostListingDTOMapper: Mapper {
    typealias IN = [RedditPostListingDTO]
    typealias OUT = PostModel

    func map(input: [RedditPostListingDTO]) -> PostModel {
        
        var post = input[0].data?.children?[0].data;
        var comments = input[1].data?.children?.map { PostModel(
            permalink: nil,
            author: $0.data?.author,
            category: $0.data?.subreddit,
            icon: $0.data?.thumbnail != nil ? URL(string: $0.data!.thumbnail!) : nil ,
            title: $0.data?.body,
            comments: nil
        )}

        return PostModel(
            permalink: nil,
            author: post?.author,
            category: post?.subreddit,
            icon: post?.thumbnail != nil ? URL(string: post!.thumbnail!) : nil,
            title: post?.title,
            comments: comments
        )
    }
}

//
// Created on: 14/9/23

import Foundation

struct RedditPostsResponseChildDataDTO: Decodable {
    let permalink: String?
    let author: String?
    let subreddit: String?
    let thumbnail: String?
    let title: String?
}

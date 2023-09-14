//
// Created on: 14/9/23

import Foundation

struct RedditPostListingChildDataDTO: Decodable {
    let author: String?
    let title: String?
    let body: String?
    let thumbnail: String?
    let subreddit: String?
}

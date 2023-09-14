//
// Created on: 14/9/23

import Combine

class RedditAPI: BaseApi {
    let baseUrl = "https://api.reddit.com/"

    func getPosts(subreddit: String, sort: String) -> AnyPublisher<RedditPostsResponseDTO, Error> {
        createRequest(path: "r/\(subreddit)/\(sort)")
    }

    func getPost(permalink: String) -> AnyPublisher<[RedditPostListingDTO], Error> {
        createRequestArray(path: permalink)
    }
}

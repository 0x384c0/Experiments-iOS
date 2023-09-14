//
// Created on: 27/3/23

import Combine
import RedditPostsDomain
import Common

class RemoteDataSourceImpl : RemoteDataSource {
    internal init(api: RedditAPI, redditPostsResponseDTOMapper: RedditPostsResponseDTOMapper, redditPostListingDTOMapper: RedditPostListingDTOMapper) {
        self.api = api
        self.redditPostsResponseDTOMapper = redditPostsResponseDTOMapper
        self.redditPostListingDTOMapper = redditPostListingDTOMapper
    }

    let api: RedditAPI
    let redditPostsResponseDTOMapper: RedditPostsResponseDTOMapper
    let redditPostListingDTOMapper: RedditPostListingDTOMapper

    let text = "Data source text"// TODO: remove

    func getPosts(subreddit: String, sort: String) -> AnyPublisher<[PostModel], Error> {
        api.getPosts(subreddit: subreddit, sort: sort)
            .map { [unowned self] input in
                self.redditPostsResponseDTOMapper.map(input: input)
            }
            .eraseToAnyPublisher()
    }

    func getPost(permalink: String) -> AnyPublisher<PostModel, Error> {
        api.getPost(permalink: permalink)
            .map { [unowned self] input in
                self.redditPostListingDTOMapper.map(input: input)
            }
            .eraseToAnyPublisher()
    }
}

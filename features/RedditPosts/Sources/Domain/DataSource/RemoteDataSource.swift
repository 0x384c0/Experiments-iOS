//
// Created on: 27/3/23

import Combine

public protocol RemoteDataSource{
    var text:String { get }// TODO: remove
    func getPosts(subreddit: String, sort: String) -> AnyPublisher<[PostModel], Error>
    func getPost(permalink: String) -> AnyPublisher<PostModel, Error>
}

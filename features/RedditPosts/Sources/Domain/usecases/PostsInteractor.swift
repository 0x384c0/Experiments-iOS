//
// Created on: 27/3/23

import Combine

public protocol PostsInteractor {
    var text:String {get}// TODO: remove
    func getPosts(subreddit: String, sort: String) -> AnyPublisher<[PostModel], Error>
    func getPost(permalink: String) -> AnyPublisher<PostModel, Error>
}

class PostsInteractorImpl: PostsInteractor {

    private let remoteDataSource:RemoteDataSource
    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    var text: String {// TODO: remove
        remoteDataSource.text
    }

    func getPosts(subreddit: String, sort: String) -> AnyPublisher<[PostModel], Error> {
        remoteDataSource.getPosts(subreddit: subreddit, sort: sort)
    }

    func getPost(permalink: String) -> AnyPublisher<PostModel, Error> {
        remoteDataSource.getPost(permalink: permalink)
    }
}

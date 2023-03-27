//
// Created on: 27/3/23

import Foundation

public protocol PostsInteractor {
    var text:String {get}
}

class PostsInteractorImpl: PostsInteractor {

    private let remoteDataSource:RemoteDataSource
    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    var text: String {
        remoteDataSource.text
    }
}

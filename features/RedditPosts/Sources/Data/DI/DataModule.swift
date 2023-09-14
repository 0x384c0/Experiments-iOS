//
// Created on: 27/3/23

import Foundation
import Common
import RedditPostsDomain

public class DataModule: BaseModule {
    public init(){}

    public func register() -> BaseModule {
        DIContainer.shared.register(RemoteDataSource.self) { r in
            RemoteDataSourceImpl(
                api: RedditAPI(),
                redditPostsResponseDTOMapper: RedditPostsResponseDTOMapper(),
                redditPostListingDTOMapper: RedditPostListingDTOMapper()
            )
        }
        return self
    }
}

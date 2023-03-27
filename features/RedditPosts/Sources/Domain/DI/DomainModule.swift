//
// Created on: 27/3/23

import Foundation
import Common

public class DomainModule: BaseModule {
    public init(){}

    public func register() -> BaseModule {
        DIContainer.shared.register(PostsInteractor.self) {r in
            PostsInteractorImpl(
                remoteDataSource: r.resolve(RemoteDataSource.self)!
            )
        }
        return self
    }
}

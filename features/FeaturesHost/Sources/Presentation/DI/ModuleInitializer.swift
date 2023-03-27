//
// Created on: 27/3/23

import Foundation
import Common
import RedditPostsDomain
import RedditPostsData

public protocol ModuleInitializer {
    var modules: [Any] { get set }
}

public extension ModuleInitializer{
    mutating func initModules() {
        if (modules.isEmpty){
            modules = [
                DataModule().register(),
                DomainModule().register(),
            ]
        }
    }
}

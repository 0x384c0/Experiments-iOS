//
//  ContentView.swift
//  Experiments-iOS
//
//  Created by 0x384c0 on 27/3/23.
//

import SwiftUI
import RedditPostsPresentation
import Common
import RedditPostsDomain

public struct ContentView: View {
    public init() {}
    public var body: some View {
        PostsView(interactor: DIContainer.shared.resolve(PostsInteractor.self)!)
    }
}

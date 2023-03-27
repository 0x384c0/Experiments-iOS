//
//  ContentView.swift
//  Experiments-iOS
//
//  Created by 0x384c0 on 27/3/23.
//

import SwiftUI
import RedditPostsPresentation

public struct ContentView: View {
    public init() {}
    public var body: some View {
        PostsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

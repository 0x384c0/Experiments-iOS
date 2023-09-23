import SwiftUI
import RedditPostsDomain
import Common
import Combine

public struct PostsView: View {
    public init(interactor: PostsInteractor) {
        _interactor = State<PostsInteractor>(initialValue: interactor)
    }

    @State
    private var interactor: PostsInteractor

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(interactor.text)
        }
        .padding()
    }
}

// For previews use this module as XCode target instead of app module
struct PostsView_Previews: PreviewProvider {
    class MockPostsInteractor: PostsInteractor {
        func getPosts(subreddit: String, sort: String) -> AnyPublisher<[PostModel], Error> {
            Just([PostModel]())
                .mapError { _ in NSError() as Error }
                .eraseToAnyPublisher()
        }

        func getPost(permalink: String) -> AnyPublisher<RedditPostsDomain.PostModel, Error> {
            Just(PostModel(permalink: nil, author: nil, category: nil, icon: nil, title: nil, comments: nil))
                .mapError { _ in NSError() as Error }
                .eraseToAnyPublisher()
        }

        var text: String = "Preview Text"
    }

    static var previews: some View {
        PostsView(interactor: MockPostsInteractor())
    }
}

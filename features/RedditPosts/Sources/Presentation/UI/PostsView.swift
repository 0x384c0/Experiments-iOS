import SwiftUI
import RedditPostsDomain
import Common

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
        var text: String = "Preview Text"
    }

    static var previews: some View {
        PostsView(interactor: MockPostsInteractor())
    }
}

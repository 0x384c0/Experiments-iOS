import SwiftUI
import RedditPostsDomain

public struct PostsView: View {
    public init() {}
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(PostsInteractor().text)
        }
        .padding()
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}

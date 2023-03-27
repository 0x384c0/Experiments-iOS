import SwiftUI
import RedditPostsDomain
import Common

public struct PostsView: View {
    public init() {}

    @State
    private var interactor = DIContainer.shared.resolve(PostsInteractor.self)!

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

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}

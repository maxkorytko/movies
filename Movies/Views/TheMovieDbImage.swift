import SwiftUI

struct TheMovieDbImage: View {
    let path: String

    @Inject
    private var appState: AppState

    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
        } placeholder: {
            Rectangle().fill(Color.blue)
        }
    }

    private var imageURL: URL? {
        appState.theMovieDbConfig
            .map(\.images)
            .result
            .flatMap { images in
                URL(string: images.secureBaseUrl)?
                    .appending(path: images.posterSizes[0])
                    .appending(path: path)
            }
    }
}

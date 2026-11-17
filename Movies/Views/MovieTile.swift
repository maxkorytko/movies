import SwiftUI

struct MovieTile: View {
    let imageKind: TheMovieDbImages.ImageKind
    let imagePath: String
    let title: String

    var body: some View {
        VStack {
            TheMovieDbImage(imageKind: imageKind, path: imagePath)

            Text(title)
                .foregroundStyle(Color.ds_textForeground)
                .font(Font.ds_headline)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}

// MARK: - Initialization

extension MovieTile {
    init(_ nowPlayingMovie: NowPlayingMovie) {
        self.imageKind = .poster
        self.imagePath = nowPlayingMovie.posterPath
        self.title = nowPlayingMovie.title
    }
}

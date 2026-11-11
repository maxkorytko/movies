import SwiftUI

struct MovieTile: View {
    let movie: Movie

    var body: some View {
        VStack {
            TheMovieDbImage(imageKind: .poster, path: movie.posterPath)

            Text(movie.title)
                .foregroundStyle(Color.ds_textForeground)
                .font(Font.ds_headline)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}

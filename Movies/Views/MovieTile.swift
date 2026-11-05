import SwiftUI

struct MovieTile: View, Themeable {
    let movie: Movie

    var body: some View {
        VStack {
            TheMovieDbImage(path: movie.posterPath)

            Text(movie.title)
                .foregroundStyle(theme.colors.textForeground)
                .font(.subheadline)
        }
    }
}

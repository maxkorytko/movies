import SwiftUI

struct MovieTile: View {
    let movie: Movie

    var body: some View {
        VStack {
            TheMovieDbImage(path: movie.posterPath)

            Text(movie.title)
                .foregroundStyle(Color.ds_textForeground)
                .font(.subheadline)
        }
    }
}

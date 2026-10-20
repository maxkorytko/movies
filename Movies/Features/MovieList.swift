import SwiftUI

struct MovieList: View {
    @State private var viewModel: ViewModel = .init()

    var body: some View {
        List(viewModel.movies) { movie in
            Text(movie.title)
        }
        .task {
            await viewModel.fetchMovies()
        }
    }
}

extension MovieList {
    @MainActor
    @Observable
    final class ViewModel {
        private let movieRepository: any MovieRepository

        private(set) var movies: [Movie] = []

        convenience init() {
            self.init(movieRepository: inject())
        }

        init(movieRepository: any MovieRepository) {
            self.movieRepository = movieRepository
        }

        func fetchMovies() async {
            do {
                let page = try await movieRepository.fetchNowPlayingMovies()
                self.movies = page.results
            } catch {
                self.movies = []
            }
        }
    }
}

#Preview {
    MovieList()
}

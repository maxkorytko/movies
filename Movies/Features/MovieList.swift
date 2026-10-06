import SwiftUI

struct MovieList: View {
    @State private var viewModel: ViewModel

    init(movieRepository: any MovieRepository) {
        _viewModel = State(
            initialValue: ViewModel(movieRepository: movieRepository)
        )
    }

    var body: some View {
        Text(viewModel.movies)
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

        private(set) var movies = ""

        init(movieRepository: any MovieRepository) {
            self.movieRepository = movieRepository
        }

        func fetchMovies() async {
            self.movies = "Movies Fetched"
        }
    }
}

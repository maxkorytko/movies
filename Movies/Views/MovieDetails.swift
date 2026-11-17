import SwiftUI

struct MovieDetails: View {
    let movieId: String

    @State private var viewModel: ViewModel = .init()

    var body: some View {
        ZStack {
            Color.ds_background
                .ignoresSafeArea()

            switch viewModel.content {
            case .loading:
                Color.clear
                    .task {
                        await viewModel.fetchMovie(movieId: movieId)
                    }
            case .success(let movie):
                Text(movie.title)
            case .failure:
                Text("Error")
            }
        }
    }
}

extension MovieDetails {
    @MainActor
    @Observable
    final class ViewModel {
        private let movieRepository: any MovieRepository

        private(set) var content: Loadable<Movie> = .loading

        convenience init() {
            self.init(movieRepository: inject())
        }

        init(movieRepository: any MovieRepository) {
            self.movieRepository = movieRepository
        }

        func fetchMovie(movieId: String) async {
            do {
                let movie = try await movieRepository.fetchMovie(movieId: movieId)
                self.content = .success(movie)
            } catch {
                self.content = .failure(error)
            }
        }
    }
}

#Preview {
    MovieDetails(movieId: "1058424")
}

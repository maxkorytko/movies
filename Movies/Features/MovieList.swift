import SwiftUI

struct MovieList: View {
    @State private var viewModel: ViewModel = .init()

    var body: some View {
        switch viewModel.content {
        case .loading:
            loadingView
        case .success(let content):
            contentView(content)
        case .failure:
            errorView
        }
    }

    private var loadingView: some View {
        Text("Loading")
            .task {
                await viewModel.fetchInitialContent()
            }
    }

    private func contentView(_ content: [Movie]) -> some View {
        List(content) { movie in
            MovieTile(movie: movie)
        }
    }

    private var errorView: some View {
        Text("Error")
    }
}

extension MovieList {
    @MainActor
    @Observable
    final class ViewModel {
        private let movieRepository: any MovieRepository

        private(set) var content: Loadable<[Movie]> = .loading

        convenience init() {
            self.init(movieRepository: inject())
        }

        init(movieRepository: any MovieRepository) {
            self.movieRepository = movieRepository
        }

        func fetchInitialContent() async {
            do {
                let page = try await movieRepository.fetchNowPlayingMovies()
                self.content = .success(page.results)
            } catch {
                self.content = .failure(error)
            }
        }
    }
}

#Preview {
    MovieList()
}

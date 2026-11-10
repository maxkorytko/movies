import SwiftUI

struct MovieCollectionView: View {
    @State private var viewModel: ViewModel = .init()

    var body: some View {
        ZStack {
            Color.ds_background
                .ignoresSafeArea()

            switch viewModel.content {
            case .loading:
                loadingView
            case .success(let movies):
                MovieGridView(movies: movies)
            case .failure:
                errorView
            }
        }
    }

    private var loadingView: some View {
        Text("Loading")
            .foregroundStyle(Color.ds_textForeground)
            .task {
                await viewModel.fetchInitialContent()
            }
    }

    private var errorView: some View {
        Text("Error")
    }
}

// MARK: MovieGridView

fileprivate struct MovieGridView: View {
    private enum Constants {
        static let columnMaxWidth: CGFloat = 250
        static let columnsHorizontalSpacing: CGFloat = .ds_small
        static let columnsVerticalSpacing: CGFloat = .ds_medium
    }

    fileprivate let movies: [Movie]

    var body: some View {
        GeometryReader { geometry in
            let columns = calculateNumberOfColumns(availableWidth: geometry.size.width)

            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(spacing: Constants.columnsHorizontalSpacing),
                        count: columns
                    ),
                    spacing: Constants.columnsVerticalSpacing
                ) {
                    ForEach(movies) { movie in
                        MovieTile(movie: movie)
                    }
                }
            }
        }
    }

    private func calculateNumberOfColumns(availableWidth: CGFloat) -> Int {
        let numberOfColumns = if availableWidth > 500 {
            3
        } else {
            2
        }

        let columnWidth = min(
            Constants.columnMaxWidth,
            floor(availableWidth / CGFloat(numberOfColumns))
        )

        return Int(floor(availableWidth / columnWidth))
    }
}

extension MovieCollectionView {
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
    MovieCollectionView()
}

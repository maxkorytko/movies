import Foundation

struct TheMovieDb {
    enum Constants {
        static let baseUrl = "https://api.themoviedb.org"
    }

    private let authTokenProvider: TheMovieDbApi.AuthTokenProvider
    private let apiClient: TheMovieDbApi.Client

    init(authTokenProvider: TheMovieDbApi.AuthTokenProvider, network: Network) {
        self.authTokenProvider = authTokenProvider
        self.apiClient = TheMovieDbApi.Client(network: network)
    }

    private func makeApiRequest<T: Decodable>(resource: TheMovieDbApi.Resource) async throws -> T {
        try await apiClient.request(
            resource: resource,
            authTokenProvider: authTokenProvider
        )
    }
}

extension TheMovieDb: MovieRepository {
    func fetchNowPlayingMovies() async throws -> Page<Movie> {
        try await makeApiRequest(resource: .nowPlayingMovies)
    }
}

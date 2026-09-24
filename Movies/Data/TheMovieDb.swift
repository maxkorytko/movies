import Foundation

struct TheMovieDb {
    enum Constants {
        static let baseUrl = "https://api.themoviedb.org"
    }

    private let authTokenProvider: TheMovieDbApi.AuthTokenProvider
    private let apiClient: TheMovieDbApi.Client

    init(authTokenProvider: TheMovieDbApi.AuthTokenProvider, urlSession: URLSession) {
        self.authTokenProvider = authTokenProvider
        self.apiClient = TheMovieDbApi.Client(urlSession: urlSession)
    }

    private func callApi<T: Decodable>(endpoint: TheMovieDbApi.Endpoint) async throws -> T {
        try await apiClient.request(
            endpoint: endpoint,
            authTokenProvider: authTokenProvider
        )
    }
}

extension TheMovieDb: Repository {
    func fetchNowPlayingMovies() async throws -> Page<Movie> {
        try await callApi(endpoint: .nowPlayingMovies)
    }
}

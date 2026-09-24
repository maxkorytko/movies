extension TheMovieDbApi.Endpoint {
    static let nowPlayingMovies: Self = .init(apiVersion: .v3, httpMethod: .get, path: "movie/now_playing")
}

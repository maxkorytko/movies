protocol MovieRepository {
    func fetchNowPlayingMovies() async throws -> Page<NowPlayingMovie>
    func fetchMovie(movieId: String) async throws -> Movie
}

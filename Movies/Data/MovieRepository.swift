protocol MovieRepository {
    func fetchNowPlayingMovies() async throws -> Page<Movie>
}

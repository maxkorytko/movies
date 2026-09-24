protocol Repository {
    func fetchNowPlayingMovies() async throws -> Page<Movie>
}

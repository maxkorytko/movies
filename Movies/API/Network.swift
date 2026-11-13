import Foundation

protocol Network {
    func data(for request: TheMovieDbApi.Request) async throws -> (Data, URLResponse)
}

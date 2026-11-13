import Foundation

struct PreviewNetwork: Network {
    enum Error: Swift.Error {
        case missingResponse
        case missingResource
    }

    // MARK: - Network

    func data(for request: TheMovieDbApi.Request) async throws -> (Data, URLResponse) {
        let data = try Self.data(for: request)

        guard let response = request.endpoint.url.map({
            HTTPURLResponse(
                url: $0,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )
        }) else {
            throw Error.missingResponse
        }

        return (data, response!)
    }

    private static func data(for request: TheMovieDbApi.Request) throws -> Data {
        let data = try dataURL(for: request).map {
            try Data(contentsOf: $0)
        }

        if let data {
            return data
        }

        throw Error.missingResource
    }

    nonisolated private static func dataURL(for request: TheMovieDbApi.Request) -> URL? {
        let resourceName = switch request.endpoint.resource {
        case .nowPlayingMovies: "movie.now_playing"
        case .movieDetails: "movie.details"
        }

        return Bundle.main.url(forResource: resourceName, withExtension: "json")
    }
}

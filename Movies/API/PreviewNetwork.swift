import Foundation

struct PreviewNetwork: Network {
    enum Error: Swift.Error {
        case invalidRequest
        case missingResponse
        case missingResource
    }

    // MARK: - Network

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let requestURL = request.url else {
            throw Error.invalidRequest
        }

        let data = try Self.data(for: requestURL)

        guard let response = HTTPURLResponse(
            url: requestURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        ) else {
            throw Error.missingResponse
        }

        return (data, response)
    }

    private static func data(for url: URL) throws -> Data {
        let data = try TheMovieDbApi.Endpoint.allCases.first { endpoint in
            url.path().contains(endpoint.path)
        }
        .map(\.path)
        .flatMap(resourceURL)
        .map { resourceURL in try Data(contentsOf: resourceURL) }

        if let data {
            return data
        }

        throw Error.missingResource
    }

    nonisolated private static func resourceURL(path: String) -> URL? {
        Bundle.main.url(
            forResource: path.replacingOccurrences(of: "/", with: "."),
            withExtension: "json"
        )
    }
}

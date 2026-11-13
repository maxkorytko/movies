import Foundation

extension URLSession: Network {
    func data(for request: TheMovieDbApi.Request) async throws -> (Data, URLResponse) {
        try await data(for: URLRequest.from(apiRequest: request))
    }
}

fileprivate extension URLRequest {
    static func from(
        apiRequest: TheMovieDbApi.Request
    ) throws(TheMovieDbApi.ApiError) -> Self {
        guard let url = apiRequest.endpoint.url else {
            throw .invalidEndpointURL
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "\(apiRequest.endpoint.httpMethod)"

        switch apiRequest.authToken {
        case .bearer(let token):
            urlRequest.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }
}

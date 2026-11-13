import Foundation

enum HttpMethod: CustomStringConvertible {
    case get

    var description: String { rawValue }

    var rawValue: String {
        switch self {
        case .get: return "GET"
        }
    }
}

enum TheMovieDbApi {
    enum Version: String {
        case v3 = "3"
    }

    enum ApiError: Error {
        case decodingFailed(underlying: Error)
        case httpError(statusCode: Int, data: Data?)
        case invalidAuthToken
        case invalidEndpointURL
        case invalidHost
        case invalidResponse
        case rateLimited(retryAfter: TimeInterval?)
        case requestFailed(underlying: Error)
        case serviceError(message: String?, statusCode: Int, retryAfter: TimeInterval?)
        case unauthorized
    }

    struct ErrorResponse: Decodable {
        let statusMessage: String?
        let statusCode: Int?

        enum CodingKeys: String, CodingKey {
            case statusMessage = "status_message"
            case statusCode = "status_code"
        }
    }

    struct Client {
        private let jsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()

        private let network: Network

        init(network: Network) {
            self.network = network
        }

        func request<T: Decodable>(
            resource: Resource,
            authTokenProvider: AuthTokenProvider
        ) async throws(ApiError) -> T {
            guard let authToken = authTokenProvider.authToken else {
                throw .invalidAuthToken
            }

            do {
                let request = Request(
                    authToken: authToken,
                    endpoint: Endpoint(for: resource)
                )

                let (data, response) = try await network.data(for: request)

                try handleResponse(response, data: data)

                do {
                    return try jsonDecoder.decode(T.self, from: data)
                } catch {
                    throw ApiError.decodingFailed(underlying: error)
                }
            } catch {
                if let apiError = error as? ApiError { throw apiError }
                throw ApiError.requestFailed(underlying: error)
            }
        }

        private func handleResponse(_ response: URLResponse, data: Data) throws(ApiError) {
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                return
            default:
                let apiErrorObject = try? jsonDecoder.decode(ErrorResponse.self, from: data)
                let retryAfterHeader = httpResponse.value(forHTTPHeaderField: "Retry-After")
                let retryAfter: TimeInterval? = retryAfterHeader.flatMap { Double($0) }
                if httpResponse.statusCode == 401 {
                    throw .unauthorized
                } else if httpResponse.statusCode == 429 {
                    throw .rateLimited(retryAfter: retryAfter)
                } else {
                    throw .serviceError(
                        message: apiErrorObject?.statusMessage,
                        statusCode: httpResponse.statusCode,
                        retryAfter: retryAfter
                    )
                }
            }
        }
    }
}

extension TheMovieDbApi {
    struct Request {
        let authToken: AuthToken
        let endpoint: Endpoint
    }
}

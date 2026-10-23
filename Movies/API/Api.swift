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

    struct Endpoint {
        let apiVersion: Version
        let httpMethod: HttpMethod
        let path: String

        init(apiVersion: Version, httpMethod: HttpMethod, path: String) {
            self.httpMethod = httpMethod
            self.path = path
            self.apiVersion = apiVersion
        }
    }
}

extension TheMovieDbApi {
    enum ApiError: Error {
        case decodingFailed(underlying: Error)
        case httpError(statusCode: Int, data: Data?)
        case invalidAuthToken
        case invalidEndpoint
        case invalidEndpointMethod
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

        func request<T: Decodable>(endpoint: Endpoint, authTokenProvider: AuthTokenProvider) async throws(ApiError) -> T {
            guard let authToken = authTokenProvider.authToken else {
                throw .invalidAuthToken
            }

            let request = try RequestBuilder()
                .authToken(authToken)
                .endpoint(endpoint)
                .build()

            do {
                log(request)

                let (data, response) = try await network.data(for: request)
                try handleResponse(response, data: data)
                do {
                    return try jsonDecoder.decode(T.self, from: data)
                } catch {
                    throw ApiError.decodingFailed(underlying: error)
                }
            } catch {
                log(request, .error, message: "\(error)")
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

fileprivate extension TheMovieDbApi {
    final class RequestBuilder {
        private(set) var authToken: AuthToken?
        private(set) var endpoint: Endpoint?

        func authToken(_ authToken: AuthToken) -> Self {
            self.authToken = authToken
            return self
        }

        func endpoint(_ endpoint: Endpoint) -> Self {
            self.endpoint = endpoint
            return self
        }

        func build() throws(ApiError) -> URLRequest {
            try URLRequest(apiRequestBuilder: self)
        }
    }
}

fileprivate extension URLRequest {
    init(apiRequestBuilder: TheMovieDbApi.RequestBuilder) throws(TheMovieDbApi.ApiError) {
        guard let url = try Self.buildRequestURL(apiRequestBuilder) else {
            throw .invalidEndpointURL
        }

        self.init(url: url)

        self.httpMethod = switch apiRequestBuilder.endpoint?.httpMethod {
        case .get: "GET"
        case nil: throw .invalidEndpointMethod
        }

        switch apiRequestBuilder.authToken {
        case .bearer(let token):
            setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case nil:
            throw .invalidAuthToken
        }

        setValue("application/json", forHTTPHeaderField: "Accept")
    }

    private static func buildRequestURL(_ apiRequestBuilder: TheMovieDbApi.RequestBuilder) throws(TheMovieDbApi.ApiError) -> URL? {
        guard let endpoint = apiRequestBuilder.endpoint else {
            throw .invalidEndpoint
        }

        var components = URLComponents(string: TheMovieDb.Constants.baseUrl)
        components?.path = "/\(endpoint.apiVersion.rawValue)/\(endpoint.path)"

        return components?.url
    }
}

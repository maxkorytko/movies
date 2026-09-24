import Foundation

extension TheMovieDbApi {
    enum AuthToken {
        case bearer(String)
    }

    struct AuthTokenProvider {
        static let dev: Self = .init(source: EnvironmentSource())

        private let source: AuthTokenSource

        init(source: AuthTokenSource) {
            self.source = source
        }

        var authToken: AuthToken? {
            retrieveAuthToken().map(AuthToken.bearer)
        }

        private func retrieveAuthToken() -> String? {
            // TODO: Replace UserDefaults with Secure Keychain
            if let authToken = UserDefaults.standard.string(forKey: "tmdb.authToken") {
                return authToken
            }

            guard let authToken = source.retrieveAuthToken() else {
                return nil
            }

            UserDefaults.standard.set(authToken, forKey: "tmdb.authToken")
            return authToken
        }
    }

    protocol AuthTokenSource {
        func retrieveAuthToken() -> String?
    }
}

private struct EnvironmentSource: TheMovieDbApi.AuthTokenSource {
    func retrieveAuthToken() -> String? {
        ProcessInfo.processInfo.environment["TMDB_AUTH_TOKEN"]
    }
}

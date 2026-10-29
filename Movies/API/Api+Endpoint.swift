extension TheMovieDbApi {
    enum Endpoint: CaseIterable {
        case nowPlayingMovies

        private var descriptor: EndpointDescriptor {
            switch self {
            case .nowPlayingMovies: .nowPlayingMovies
            }
        }

        var apiVersion: Version { descriptor.apiVersion }
        var httpMethod: HttpMethod { descriptor.httpMethod }
        var path: String { descriptor.path }
    }

    fileprivate struct EndpointDescriptor {
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

extension TheMovieDbApi.EndpointDescriptor {
    static let nowPlayingMovies = Self(apiVersion: .v3, httpMethod: .get, path: "movie/now_playing")
}

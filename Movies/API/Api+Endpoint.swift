import Foundation

extension TheMovieDbApi {
    enum Resource {
        case nowPlayingMovies
        case movieDetails(movieId: String)
    }
}

extension TheMovieDbApi {
    final class Endpoint {
        let apiVersion: Version
        let httpMethod: HttpMethod
        let path: String
        let resource: Resource

        lazy var url: URL? = makeURL()

        init(for resource: Resource) {
            let apiVersion = TheMovieDbApi.Version.v3
            let httpMethod = HttpMethod.get

            switch resource {
            case .nowPlayingMovies:
                self.path = "movie/now_playing"
            case .movieDetails(let movieId):
                self.path = "movie/\(movieId)"
            }

            self.apiVersion = apiVersion
            self.httpMethod = httpMethod
            self.resource = resource
        }

        private func makeURL() -> URL? {
            var components = URLComponents(string: TheMovieDb.Constants.baseUrl)
            components?.path = "/\(apiVersion.rawValue)/\(path)"

            return components?.url
        }
    }
}

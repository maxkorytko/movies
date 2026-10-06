import Foundation

struct AppDependencies {
    let movieRepository: any MovieRepository

    static let live = AppDependencies(
        movieRepository: TheMovieDb(authTokenProvider: .dev, urlSession: .shared)
    )
}

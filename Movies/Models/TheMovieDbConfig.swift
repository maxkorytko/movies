struct TheMovieDbConfig: Decodable {
    let images: Images
}

extension TheMovieDbConfig {
    struct Images: Decodable {
        let secureBaseUrl: String
        let posterSizes: [String]
    }
}

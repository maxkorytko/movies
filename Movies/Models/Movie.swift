struct Movie: Decodable, Identifiable {
    let id: Int
    let overview: String
    let posterPath: String
    let title: String
}

struct Page<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}

struct Movie: Decodable {
    let id: Int
    let title: String
}

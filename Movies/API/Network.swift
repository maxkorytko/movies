import Foundation

protocol Network {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Network {}

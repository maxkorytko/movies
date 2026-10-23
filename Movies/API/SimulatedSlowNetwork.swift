import Foundation

struct SimulatedSlowNetwork: Network {
    private let wrappedNetwork: Network

    init(network: Network) {
        self.wrappedNetwork = network
    }

    // MARK: - Network

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await Task.sleep(for: .seconds(Int.random(in: 1...5)))
        return try await wrappedNetwork.data(for: request)
    }
}

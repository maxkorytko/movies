final class AppController {
    private(set) var appState: AppState = .init()

    func start() {
        Task {
            await fetchTheMovieDbConfig()
        }
    }

    private func fetchTheMovieDbConfig() async {
        try? await Task.sleep(for: .seconds(5))

        appState.theMovieDbConfig = .success(.init(
            images: .init(
                secureBaseUrl: "https://image.tmdb.org/t/p/",
                posterSizes: [
                    "w92",
                    "w154",
                    "w185",
                    "w342",
                    "w500",
                    "w780",
                    "original"
                ])
        ))
    }
}

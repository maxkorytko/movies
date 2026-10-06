import SwiftUI

@main
struct MoviesApp: App {
    private let dependencies = AppDependencies.live

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}

struct RootView: View {
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var body: some View {
        MovieList(movieRepository: dependencies.movieRepository)
    }
}

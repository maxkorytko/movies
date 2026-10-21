import OSLog
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        DI.container = DIContainer()
        setupDependencies()
        return true
    }

    private func setupDependencies() {
        DI.container.bindLazy(Logger.self) {
            Logger(subsystem: Bundle.main.bundleIdentifier!, category: "app")
        }

        DI.container.bind(Network.self, SimulatedSlowNetwork(network: URLSession.shared))

        DI.container.bindLazy(MovieRepository.self) {
            TheMovieDb(authTokenProvider: .dev, network: inject())
        }
    }
}

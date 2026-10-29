import OSLog
import UIKit

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

final class AppDelegate: NSObject, UIApplicationDelegate {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "app")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        DI.container = DIContainer()
        setupDependencies()
        return true
    }

    private func setupDependencies() {
        DI.container.bind(Logger.self, logger)

        DI.container.bind(Network.self, {
            if isPreview {
                logger.info("PreviewNetwork bound to Network.self")
                return PreviewNetwork()
            }
            return SimulatedSlowNetwork(network: URLSession.shared)
        }())

        DI.container.bindLazy(MovieRepository.self) {
            TheMovieDb(authTokenProvider: .dev, network: inject())
        }
    }
}

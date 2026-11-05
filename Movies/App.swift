import SwiftUI

@main
struct MoviesApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    var body: some View {
        MovieCollectionView()
    }
}

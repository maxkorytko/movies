import SwiftUI

@Observable
final class AppState {
    var theMovieDbConfig: Loadable<TheMovieDbConfig> = .loading
    var theme: AppTheme = DarkTheme()
}

import SwiftUI

@Observable
final class AppState {
    var theMovieDbConfig: Loadable<TheMovieDbConfig> = .loading
}

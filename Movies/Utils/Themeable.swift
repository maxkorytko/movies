protocol Themeable {
    var theme: AppTheme { get }
}

extension Themeable {
    var theme: AppTheme { inject(AppState.self).theme }
}

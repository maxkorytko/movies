import SwiftUI

protocol AppTheme {
    var colors: AppThemeColors { get }
}

struct AppThemeColors {
    let background: Color
    let textForeground: Color

    static fileprivate let dark: Self = Self(
       background: Color(hex: "#1F1F29"),
       textForeground: Color(hex: "#FFFFFF")
    )
}

struct DarkTheme: AppTheme {
    let colors: AppThemeColors = .dark
}

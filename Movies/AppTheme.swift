import SwiftUI

struct AppTheme {
    let colors: DesignSystem.Colors
    let spacing: DesignSystem.Spacing

    init(
        colors: DesignSystem.Colors,
        spacing: DesignSystem.Spacing
    ) {
        self.colors = colors
        self.spacing = spacing
    }

    static func dark() -> Self {
        Self(
            colors: DesignSystem.darkThemeColors,
            spacing: DesignSystem.defaultSpacing
        )
    }
}

import SwiftUI

struct AppTheme {
    let colors: DesignSystem.Colors
    let spacing: DesignSystem.Spacing
    let typography: DesignSystem.Typography

    init(
        colors: DesignSystem.Colors = DesignSystem.defaultColors,
        spacing: DesignSystem.Spacing = DesignSystem.defaultSpacing,
        typography: DesignSystem.Typography = DesignSystem.defaultTypography
    ) {
        self.colors = colors
        self.spacing = spacing
        self.typography = typography
    }
}

import SwiftUI

enum DesignSystem {
    static var darkThemeColors: Colors {
        Colors(
           background: Color(hex: "#1F1F29"),
           textForeground: Color(hex: "#FFFFFF")
        )
    }

    static var defaultSpacing: Spacing {
        Spacing(
            small: 8,
            medium: 12
        )
    }
}

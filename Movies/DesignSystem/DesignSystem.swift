import SwiftUI

enum DesignSystem {
    static var defaultColors: Colors {
        Colors(
            background: Color(.Colors.background),
            grey: Color(.Colors.grey),
            textForeground: Color(.Colors.textForeground)
        )
    }

    static var defaultSpacing: Spacing {
        Spacing(
            small: 8,
            medium: 12
        )
    }

    static var defaultTypography: Typography {
        Typography(
            headline: .headline
        )
    }
}

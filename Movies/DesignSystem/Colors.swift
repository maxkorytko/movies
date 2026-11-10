import SwiftUI

extension DesignSystem {
    struct Colors {
        let background: Color
        let textForeground: Color
    }
}

extension SwiftUI.Color {
    static var ds_background: Self { inject(AppState.self).theme.colors.background }
    static var ds_textForeground: Self { inject(AppState.self).theme.colors.textForeground }
}

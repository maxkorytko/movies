import SwiftUI

extension DesignSystem {
    struct Typography {
        let headline: Font
    }
}

extension Font {
    static var ds_headline: Self { inject(AppState.self).theme.typography.headline }
}

import Foundation

extension DesignSystem {
    struct Spacing {
        let small: CGFloat
        let medium: CGFloat
    }
}

extension CGFloat {
    static var ds_small: Self { inject(AppState.self).theme.spacing.small }
    static var ds_medium: Self { inject(AppState.self).theme.spacing.medium }
}

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1) {
        let normalizedHex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        let hexValue = UInt(normalizedHex, radix: 16) ?? 0

        self.init(
            .sRGB,
            red: Double((hexValue >> 16) & 0xFF) / 255,
            green: Double((hexValue >> 8) & 0xFF) / 255,
            blue: Double(hexValue & 0xFF) / 255,
            opacity: opacity
        )
    }
}

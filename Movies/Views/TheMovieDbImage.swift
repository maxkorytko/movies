import SwiftUI

struct TheMovieDbImage: View {
    let path: String

    @Environment(\.displayScale)
    private var displayScale

    @State private var containerWidth: CGFloat = 0

    @Inject
    private var appState: AppState

    var body: some View {
        AsyncImage(url: imageURL(containerWidth: containerWidth)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Rectangle().fill(Color.blue)
        }
        .aspectRatio(2.0 / 3.0, contentMode: .fit)
        .onGeometryChange(for: CGFloat.self) { geometry in
            geometry.size.width
        } action: { newWidth in
            containerWidth = newWidth
        }
    }

    private func imageURL(containerWidth: CGFloat) -> URL? {
        guard containerWidth > 0 else {
            return nil
        }

        return appState.theMovieDbConfig
            .map(\.images)
            .result
            .flatMap { images in
                let requiredPixelWidth = containerWidth * displayScale

                guard let imageSize = Self.bestImageSize(
                    from: images.posterSizes,
                    requiredPixelWidth: requiredPixelWidth
                ) else {
                    return nil
                }

                return URL(string: images.secureBaseUrl)?
                    .appending(path: imageSize)
                    .appending(path: path)
            }
    }

    static func bestImageSize(
        from availableSizes: [String],
        requiredPixelWidth: CGFloat
    ) -> String? {
        let fixedWidthSizes = availableSizes.compactMap { size -> (name: String, width: CGFloat)? in
            guard size.first == "w",
                  let width = Double(size.dropFirst()),
                  width > 0 else {
                return nil
            }

            return (size, CGFloat(width))
        }
        .sorted { $0.width < $1.width }

        if let bestFit = fixedWidthSizes.first(where: { $0.width >= requiredPixelWidth }) {
            return bestFit.name
        }

        return availableSizes.contains("original")
            ? "original"
            : fixedWidthSizes.last?.name
    }
}

#Preview(
    "small",
    traits: .fixedLayout(width: 150, height: 200)
) {
    TheMovieDbImage(path: "/6VY1ZKgpsc8CfGsQcCGiYEgHdH0.jpg")
        .border(.red)
}

#Preview(
    "large",
    traits: .fixedLayout(width: 350, height: 500)
) {
    TheMovieDbImage(path: "/6VY1ZKgpsc8CfGsQcCGiYEgHdH0.jpg")
}

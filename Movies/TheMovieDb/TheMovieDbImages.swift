import Foundation

struct TheMovieDbImages: Decodable {
    enum ImageKind {
        case poster
    }

    let secureBaseUrl: String
    let posterSizes: [String]
}

extension TheMovieDbImages {
    func imageURL(
        for imageKind: ImageKind,
        requiredImageWidthInPixels: CGFloat
    ) -> URL? {
        guard let imageWidth = Self.selectBestImageWidth(
            availableSizes: {
                switch imageKind {
                case .poster: posterSizes
                }
            }(),
            requiredSize: requiredImageWidthInPixels
        ) else {
            return nil
        }

        return URL(string: secureBaseUrl)?.appending(path: imageWidth)
    }

    private static func selectBestImageWidth(
        availableSizes: [String],
        requiredSize: CGFloat
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

        if let bestFit = fixedWidthSizes.first(where: {
            $0.width >= requiredSize
        }) {
            return bestFit.name
        }

        return availableSizes.contains("original")
            ? "original"
            : fixedWidthSizes.last?.name
    }
}

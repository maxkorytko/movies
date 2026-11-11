import SwiftUI

struct TheMovieDbImage: View {
    private enum Constants {
        static let aspectRatio: CGFloat = 2.0 / 3.0
        static let cornerRadius: CGFloat = 10
    }

    let imageKind: TheMovieDbImages.ImageKind
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
            Rectangle().fill(Color.ds_grey)
        }
        .aspectRatio(Constants.aspectRatio, contentMode: .fit)
        .clipShape(.rect(cornerRadius: Constants.cornerRadius))
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
                images.imageURL(
                    for: imageKind,
                    requiredImageWidthInPixels: containerWidth * displayScale
                )?
                .appending(path: path)
            }
    }
}

#Preview(
    "small",
    traits: .fixedLayout(width: 150, height: 200)
) {
    TheMovieDbImage(
        imageKind: .poster,
        path: "/6VY1ZKgpsc8CfGsQcCGiYEgHdH0.jpg"
    )
    .border(.red)
}

#Preview(
    "large",
    traits: .fixedLayout(width: 350, height: 500)
) {
    TheMovieDbImage(
        imageKind: .poster,
        path: "/6VY1ZKgpsc8CfGsQcCGiYEgHdH0.jpg"
    )
}

//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Maksym Korytko on 9/16/26.
//

import CoreGraphics
import Testing
@testable import Movies

struct MoviesTests {
    private let availableSizes = [
        "w92", "w154", "w185", "w342", "w500", "w780", "original"
    ]

    @Test func imageSizeIsTheSmallestSizeThatAvoidsUpscaling() {
        let imageSize = TheMovieDbImage.bestImageSize(
            from: availableSizes,
            requiredPixelWidth: 343
        )

        #expect(imageSize == "w500")
    }

    @Test func imageSizeSelectionDoesNotDependOnServerOrder() {
        let imageSize = TheMovieDbImage.bestImageSize(
            from: ["original", "w500", "w92", "w342"],
            requiredPixelWidth: 300
        )

        #expect(imageSize == "w342")
    }

    @Test func originalImageIsUsedWhenFixedSizesAreTooSmall() {
        let imageSize = TheMovieDbImage.bestImageSize(
            from: availableSizes,
            requiredPixelWidth: 1_000
        )

        #expect(imageSize == "original")
    }

    @Test func largestFixedImageIsFallbackWhenOriginalIsUnavailable() {
        let imageSize = TheMovieDbImage.bestImageSize(
            from: ["invalid", "w342", "w92"],
            requiredPixelWidth: 1_000
        )

        #expect(imageSize == "w342")
    }
}

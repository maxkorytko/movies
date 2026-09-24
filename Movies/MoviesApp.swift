//
//  MoviesApp.swift
//  Movies
//
//  Created by Maksym Korytko on 9/16/26.
//

import SwiftUI

@main
struct MoviesApp: App {
    let apiClient = TheMovieDb(authTokenProvider: .dev, urlSession: .shared)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    let movies = try? await apiClient.fetchNowPlayingMovies()
                }
        }
    }
}

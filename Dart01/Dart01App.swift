//
//  Dart01App.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI

@main
struct Dart01App: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(games: $userData.games) {
//                MainView(games: $userData.games) {
                    Task {
                        do {
                            try await userData.save(games: userData.games)
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                .task {
                    do {
                        try await userData.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

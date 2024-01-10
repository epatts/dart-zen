//
//  Dart01App.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI
import SwiftData

@main
struct Dart01App: App {
    @StateObject private var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(games: $userData.games) {
//                    Task {
//                        do {
//                            try await userData.save(games: userData.games)
//                        } catch {
//                            fatalError(error.localizedDescription)
//                        }
//                    }
                    
                    
                }
//                .task {
//                    do {
//                        try await userData.load()
//                    } catch {
//                        fatalError(error.localizedDescription)
//                    }
//                }
            }
        }
        .modelContainer(for: [Leg.self])
    }
}

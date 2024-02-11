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
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(.stack)
        }
        .modelContainer(for: [Leg.self, CommonScorePad.self])
    }
}

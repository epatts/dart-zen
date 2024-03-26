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
    @StateObject var screenSize = ScreenSize()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .onRotate { _ in
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        screenSize.height = UIScreen.main.bounds.height
                        screenSize.width = UIScreen.main.bounds.width
                    }
                }
            }
            .navigationViewStyle(.stack)
            .environmentObject(screenSize)
        }
        .modelContainer(for: [Leg.self, CommonScorePad.self])
    }
}

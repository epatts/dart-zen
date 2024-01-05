//
//  MainView.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct MainView: View {
    @Binding var games: [Game]
    let saveAction: ()->Void
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ContentView(games: $games)
            .onRotate { newOrientation in
                UserData.orientation = newOrientation
            }
            .onChange(of: scenePhase) {
                if scenePhase == .inactive { saveAction() }
            }
    }
}

#Preview {
    MainView(games: .constant([]), saveAction: {})
}

//
//  SessionMenu.swift
//  Dart01
//
//  Created by Eric Patterson on 4/5/24.
//

import SwiftUI
import SwiftData

struct SessionMenu: View {
    @Environment(\.modelContext) var context

    @Query var sessions: [Session]
    
    @State private var editMode = false
    
    private func delete(_ session: Session) {
        context.delete(session)
    }

    var body: some View {
        NavigationStack() {
            List (sessions) { session in
                NavigationLink(value: session) {
                    Text(session.name)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        delete(session)
                    }
                }
            }
            .navigationDestination(for: Session.self) { session in
                if editMode {
                    EditSessionView(session: session)
                } else {
                    ContentView(session: session)
                }
            }
            
        }
        .navigationTitle("Sessions")
        .toolbar {
            Button("Add Session", systemImage: "plus") {
                let session = Session(legs: [])

                context.insert(session)
            }
            
            Button("Edit", systemImage: editMode ? "checkmark" : "square.and.pencil") {
                editMode.toggle()
            }
        }
    }
}

struct EditSessionView: View {
    @Bindable var session: Session

    var body: some View {
        Form {
            TextField("Name", text: $session.name)
//            DatePicker("Join Date", selection: $session.dart)
        }
        .navigationTitle("Edit Session")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Leg.self, Session.self, configurations: config)
        
        var legs: [Leg] = []
        
        for i in 1..<4 {
            legs.append(Leg(gameType: ._501, scores: [100, 140, 100, 81, 60, 20], average: 83.5, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now))
        }
        
        let session = Session(legs: legs, darts: Dart(brand: "Winmau"), name: "Main")
        let session2 = Session(legs: legs, darts: Dart(brand: "Winmau"), name: "Second")
        let session3 = Session(legs: legs, darts: Dart(brand: "Winmau"), name: "Third")

            
        container.mainContext.insert(session)
        container.mainContext.insert(session2)
        container.mainContext.insert(session3)
        
        return NavigationStack {
                    SessionMenu()
                }
                .modelContainer(container)
        } catch {
            return Text("Failed to create container: \(error.localizedDescription)")
        }
    
}

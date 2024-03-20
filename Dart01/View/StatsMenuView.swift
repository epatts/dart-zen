//
//  StatsMenuView.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI
import SwiftData

struct StatsMenuView: View {
    @Environment(\.modelContext) var context
    
    @ObservedObject var viewModel = ScoreViewModel()

    @Query(sort: \Leg.date) var legs: [Leg]
    
    var body: some View {
        VStack (spacing: 0) {
            if !legs.isEmpty {
                List {
                    ForEach(legs) { leg in
                        VStack (spacing: 0) {
                            StatsLegListItemView(leg: leg)
                            
                            Divider()
                                .overlay(Color(.neutralLight))
                        }
                        .overlay {
                            NavigationLink("", destination: LegStatsDetailView(leg: leg))
                                .opacity(0)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(legs[index])
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                Text("Go play some darts!")
                    .foregroundStyle(Color(.textLight))
                    .font(.title3Regular)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.neutralXlight))
        .backButtonWithTitleNavBarStyle(title: "Statistics")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button() {
                    do {
                        try context.delete(model: Leg.self)
                    } catch {
                        print("Failed to delete legs.")
                    }
                    
                    viewModel.resetStats()
                } label: {
                    Text("Delete All")
                        .font(.bodySemiBold)
                        .foregroundStyle(Color(.primaryDark))
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Leg.self, configurations: config)

        for i in 1..<4 {
            let leg = Leg(gameType: ._501, scores: ["100", "140", "100", "81", "60", "20"], average: 83.5, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
            container.mainContext.insert(leg)
        }

        return NavigationView {
            StatsMenuView()
        }
        .navigationViewStyle(.stack)
        .modelContainer(container)
}

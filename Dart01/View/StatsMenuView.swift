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
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: ScoreViewModel
    
    @Query(sort: \Leg.date, order: .reverse) var legs: [Leg]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            if !legs.isEmpty {
                
                VStack (alignment: .leading, spacing: 0) {                    
                        CollapsableContent(
                            title: "Stats",
                            content: StatsAveragesView(viewModel: viewModel))
                        
                        
                        Divider()
                            .overlay {
                                Color(.neutralXdark)
                            }
                            .padding(.vertical, .medium)
                }
                
                CollapsableContent(
                    title: "Legs",
                    content: 
                        List {
                        ForEach(legs) { leg in
                            VStack (spacing: 0) {
                                StatsLegListItemView(leg: leg)
                                
                                Divider()
                                    .overlay(Color(.neutralXdark))
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
                                try? context.save()
                                viewModel.resetStats()
                                viewModel.setUpData(legs)
                            }
                        }
                    }
                        .listStyle(.plain)
                )
                
                Spacer()
            } else {
                Text("Go play some darts!")
                    .foregroundStyle(Color(.textLight))
                    .font(.title3Regular)
            }
        }
        .padding(.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.neutralXlight))
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button() {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.bodySemiBold)
                        .foregroundStyle(Color(.primaryDark))
                }
            }
            
            ToolbarItemGroup(placement: .principal) {
                Text("Statistics")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
            }
            
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
            let leg = Leg(gameType: ._501, scores: [100, 140, 100, 81, 60, 20], average: 83.5, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
            container.mainContext.insert(leg)
        }

        return NavigationView {
            StatsMenuView(viewModel: ScoreViewModel())
        }
        .navigationViewStyle(.stack)
        .modelContainer(container)
}

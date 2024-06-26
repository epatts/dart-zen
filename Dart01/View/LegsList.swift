//
//  LegsList.swift
//  Dart01
//
//  Created by Eric Patterson on 4/8/24.
//

import SwiftUI
import SwiftData

struct LegsList: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss

    @State var showingDeleteConfirmationAlert = false
    
    @ObservedObject var viewModel: ScoreViewModel
    
    @Query(sort: \Leg.date, order: .reverse) var legs: [Leg]
    
    var body: some View {
        VStack {
            VStack {
                List {
                    ForEach(legs) { leg in
                        VStack (spacing: 0) {
                            StatsLegListItemView(leg: leg)
                                .padding([.vertical, .trailing], .extraExtraSmall)
                        }
                        .overlay {
                            NavigationLink("", destination: LegStatsDetailView(viewModel: viewModel, leg: leg))
                                .opacity(0)
                        }
                        .listRowBackground(Color(.neutralXlight))
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
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.medium)
            
            Button() {
                showingDeleteConfirmationAlert = true
            } label: {
                Text("Delete All")
                    .font(.bodySemiBold)
                    .foregroundStyle(Color(.errorBase))
            }
            .padding(.medium)
            .alert("Are you sure?", isPresented: $showingDeleteConfirmationAlert) {
                Button("Delete", role: .destructive) {
                    do {
                        try context.delete(model: Leg.self)
                    } catch {
                        print("Failed to delete legs.")
                    }
                    
                    viewModel.resetStats()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You will not be able to recover your statistics once they are deleted.")
            }
        }
        .background(Color(.neutralXlight))
        .backButtonWithTitleNavBarStyle(title: "Legs")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Leg.self, configurations: config)

    for leg in Leg.exampleData(8) {
        container.mainContext.insert(leg)
    }

    return NavigationView {
        LegsList(viewModel: ScoreViewModel())
    }
    .navigationViewStyle(.stack)
    .modelContainer(container)
}

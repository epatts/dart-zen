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
    
    @Bindable var session: Session
    
//    @Query(sort: \Leg.date, order: .reverse) var legs: [Leg]
    
    @State var showingDeleteConfirmationAlert = false
    
    private func removeRows(at offsets: IndexSet) {
        session.legs.remove(atOffsets: offsets)
        
        viewModel.resetStats()
        viewModel.setUpData(session.legs)
    }
    
    var body: some View {
        VStack (alignment: .center, spacing: 0) {
            if !session.legs.isEmpty {
                
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
                    title: "Scores",
                    content: StatsBigScoreDistributionView(viewModel: viewModel))
                
                
                Divider()
                    .overlay {
                        Color(.neutralXdark)
                    }
                    .padding(.vertical, .medium)
                
                CollapsableContent(
                    title: "Legs",
                    content: 
                        List {
                            ForEach(session.legs) { leg in
                                VStack (spacing: 0) {
                                    StatsLegListItemView(leg: leg)
                                    
                                    Divider()
                                        .overlay(Color(.neutralXlight))
                                        .padding(.vertical, .extraExtraSmall)
                                }
                                .overlay {
                                    NavigationLink("", destination: LegStatsDetailView(leg: leg))
                                        .opacity(0)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                            }
                            .onDelete(perform: removeRows)
//                            .onDelete { indexSet in
//                                for index in indexSet {
//                                    context.delete(legs[index])
//                                    try? context.save()
//                                    viewModel.resetStats()
//                                    viewModel.setUpData(legs)
//                                }
//                            }
                    }
                        .listStyle(.plain)
                )
                
                Spacer()
                
                Button() {
                    showingDeleteConfirmationAlert = true
                } label: {
                    Text("Delete All")
                        .font(.bodySemiBold)
                        .foregroundStyle(Color(.errorBase))
                }
                .padding(.top, .medium)
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
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button() {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.bodySemiBold)
                        .foregroundStyle(Color(.primaryDark))
                }
            }
            
            ToolbarItemGroup(placement: .principal) {
                Text("Statistics")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
            }
        }
        .alert("Are you sure?", isPresented: $showingDeleteConfirmationAlert) {
            Button("Delete", role: .destructive) {
                do {
//                    try context.delete(model: Leg.self)
                    session.legs.removeAll()
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
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, Session.self, configurations: config)

    var legs = [Leg]()
    
    for i in 1..<4 {
        legs.append(Leg(gameType: ._501, scores: [100, 140, 100, 81, 60, 20], average: 83.5 - Double((i * 4)), numDarts: 18 + i, dartsAtDouble: 3, completed: true, date: Date.now))
//            container.mainContext.insert(leg)
    }
    
    let session = Session(legs: legs, darts: Dart(brand: "Winmau"), name: "Main Session")
    
    container.mainContext.insert(session)

    return NavigationView {
        StatsMenuView(viewModel: ScoreViewModel(), session: session)
    }
    .navigationViewStyle(.stack)
    .modelContainer(container)
}

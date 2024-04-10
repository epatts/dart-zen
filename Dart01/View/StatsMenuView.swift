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
    
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @ObservedObject var viewModel: ScoreViewModel
    
    @Query(sort: \Leg.date, order: .reverse) var legs: [Leg]
        
    var body: some View {
        VStack (alignment: .center, spacing: 0) {
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
                    title: "Scores",
                    content: StatsBigScoreDistributionView(viewModel: viewModel))
                
                Divider()
                    .overlay {
                        Color(.neutralXdark)
                    }
                    .padding(.vertical, .medium)
                
                CollapsableContent(
                    title: "Graph",
                    content: Graph(viewModel: viewModel)
                )
                
                Divider()
                    .overlay {
                        Color(.neutralXdark)
                    }
                    .padding(.vertical, .medium)
                
                NavigationLink {
                    LegsList(viewModel: viewModel)
                } label : {
                    HStack (spacing: 0) {
                        Text("View Legs List")
                            .font(.title3SemiBold)
                            .foregroundStyle(Color.textBase)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.bodySemiBold)
                            .foregroundStyle(Color.secondaryDark)
                    }
                }
                
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
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Leg.self, configurations: config)

    for leg in Leg.exampleData(20) {
        container.mainContext.insert(leg)
    }

    return NavigationView {
        StatsMenuView(viewModel: ScoreViewModel())
    }
    .navigationViewStyle(.stack)
    .modelContainer(container)
}

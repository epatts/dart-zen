//
//  ContentView.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
    
    @ObservedObject var viewModel = ScoreViewModel()
        
    @Query(sort: \Leg.average) var legs: [Leg]
    
    let saveAction: ()-> Void
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                
                ScoreView(score: viewModel.total)
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical)
                
                InGameStatsBar(viewModel: viewModel)
                
                Text("Legs: \(legs.count)")
                    .font(Theme.Fonts.raleway(.body, .body))
                
                Spacer()
                
                HStack {
                    Text(" ")
                        .font(Theme.Fonts.ralewaySemiBold(.title, .title))
                    
                    Text(viewModel.scoreString)
                        .font(Theme.Fonts.ralewaySemiBold(.title, .title))
                }
                
                Spacer()
                
                NumberPad(viewModel: viewModel)
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical)
                
                CommonScoresPad(viewModel: viewModel)
            }
//            .onChange(of: viewModel.games) {
//                games = viewModel.games
//            }
            .padding()
            .alert("Game shot!", isPresented: $viewModel.showingCheckoutPopup) {
                Button("1") {
                    viewModel.checkout(viewModel.scoreHistory.last, 1)
                    context.insert(Leg(gameType: ._501, scores: viewModel.scoreHistory, checkoutScore: viewModel.scoreHistory.last, average: viewModel.overallAverage))
                }
                Button("2") { 
                    viewModel.checkout(viewModel.scoreHistory.last, 2)
                    context.insert(Leg(gameType: ._501, scores: viewModel.scoreHistory, checkoutScore: viewModel.scoreHistory.last, average: viewModel.overallAverage))
                }
                Button("3") { 
                    viewModel.checkout(viewModel.scoreHistory.last, 3)
                    context.insert(Leg(gameType: ._501, scores: viewModel.scoreHistory, checkoutScore: viewModel.scoreHistory.last, average: viewModel.overallAverage))
                }
                Button("Cancel", role: .cancel) { 
                    viewModel.undoLastScore()
                }
            } message: {
                Text("How many darts did it take you to checkout?")
            }
        }
        .background(Color(.neutralXlight))
        .onChange(of: scenePhase) {
            if scenePhase == .inactive { saveAction() }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                if !viewModel.scoreHistory.isEmpty {
                    Button() {
                        viewModel.undoLastScore()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                                .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                                .foregroundStyle(Color(.primaryDark))
                            
                            Text("Undo")
                                .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                                .foregroundStyle(Color(.primaryDark))
                        }
                    }
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button() {
                    viewModel.newGame()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                            .foregroundStyle(Color(.primaryDark))

                        Text(viewModel.gameOver ? "New Game" : "Restart Game")
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                            .foregroundStyle(Color(.primaryDark))
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
//        ContentView(viewModel: Fixtures().getScoreViewModel())
        ContentView(saveAction: {})
//        ContentView()
    }
}

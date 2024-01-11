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
        
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                
                ScoreView(score: viewModel.total)
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical)
                
                InGameStatsBar(viewModel: viewModel)
                
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
            .padding()
            .alert("Game shot!", isPresented: $viewModel.showingCheckoutPopup) {
                Button("1") {
                    viewModel.checkout(viewModel.scoreHistory.last, 1, context: context)
                }
                Button("2") { 
                    viewModel.checkout(viewModel.scoreHistory.last, 2, context: context)
                }
                Button("3") { 
                    viewModel.checkout(viewModel.scoreHistory.last, 3, context: context)
                }
                Button("Cancel", role: .cancel) { 
                    viewModel.undoLastScore()
                }
            } message: {
                Text("How many darts did it take you to checkout?")
            }
        }
        .onAppear {
            viewModel.setUpData(legs)
        }
        .background(Color(.neutralXlight))
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
        ContentView()
//        ContentView()
    }
}

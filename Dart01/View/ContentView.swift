//
//  ContentView.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var viewModel = ScoreViewModel()
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                
                ScoreView(score: $viewModel.total)
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical)
                
                HStack {
                    Text("Last: \(viewModel.scoreHistory.last ?? "-")")
                        .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                    
                    Spacer()
                    
                    Text("Darts thrown: \(viewModel.scoreHistory.count * 3)")
                        .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                    
                    Spacer()
                    
                    if !viewModel.scoreHistory.isEmpty || viewModel.totalDartsThrown != 0 {
                        Text("Avg: \(viewModel.overallAverage, specifier: "%.2f")")
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                    } else {
                        Text("Avg: -")
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                    }
                }
                
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
                    viewModel.checkout(viewModel.scoreHistory.last, 1)
                }
                Button("2") { 
                    viewModel.checkout(viewModel.scoreHistory.last, 2)
                }
                Button("3") { 
                    viewModel.checkout(viewModel.scoreHistory.last, 3)
                }
                Button("Cancel", role: .cancel) { 
                    viewModel.undoLastScore()
                }
            } message: {
                Text("How many darts did it take you to checkout?")
            }
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
    }
}

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
        
    @State private var isRecording = false
    @State private var transcript = "Test"
    
    @GestureState private var isDetectingPress = false
    
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "←", "0", "Enter"]
    
    let commonScores = ["26", "41", "45", "60", "81", "85", "100", "121", "125", "133", "140", "180"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let commonScoreColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                
                Text("\(viewModel.total)")
                    .font(Theme.Fonts.ralewaySemiBold(180, .largeTitle))
                    .frame(maxWidth: .infinity)
                    .contentTransition(.numericText(countsDown: true))
                    .padding(.top, -40)
                
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
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(numbers, id: \.self) { number in
                        Text(number)
                            .font(Theme.Fonts.ralewaySemiBold(.title2, .title2))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .padding(14)
                            .foregroundStyle(Color(.textXlight))
                            .background(Color(.primaryDark))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            .onTapGesture {
                                if number == "←" {
                                    if !viewModel.scoreString.isEmpty {
                                        viewModel.scoreString.removeLast()
                                        if viewModel.scoreString.count > 1 {
                                            viewModel.startTimer()
                                        } else if viewModel.scoreString.count == 1 {
                                            viewModel.numberTapWorkItem?.cancel()
                                        }
                                    }
                                } else if number == "Enter" {
                                    viewModel.numberTapWorkItem?.cancel()
                                    viewModel.handleScore(viewModel.scoreString)
                                    viewModel.scoreString.removeAll()
                                } else {
                                    if viewModel.scoreString.count < 3 {
                                        viewModel.scoreString.append(number)
                                    }
                                    viewModel.startTimer()
                                }
                            }
                    }
                }
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical)
                
                LazyVGrid(columns: commonScoreColumns, alignment: .center, spacing: 10) {
                    ForEach(commonScores, id: \.self) { number in
                        Text(number)
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .padding(10)
                            .foregroundStyle(Color(.textBase))
                            .background(Color(.neutralLight))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            .blur(radius: isRecording ? 4 : 0)
                            .onTapGesture {
                                viewModel.handleScore(number)
                            }
                    }
                }
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

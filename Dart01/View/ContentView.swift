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
                
                if CheckoutNumbers.shared.isCheckoutNumber(viewModel.total) {
                    HStack {
                        ForEach((viewModel.getCheckoutType()...3), id: \.self) { number in
                            if viewModel.getCheckoutType() == 2 {
                                Spacer()
                            }
                            
                            ZStack {
                                Image(systemName: "app.badge.checkmark")
                                    .font(.largeTitle)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color(.primaryDark), Color(.textBase))
                                
                                Text("\(number)")
                                    .font(Theme.Fonts.ralewaySemiBold(.title3, .title3))
                                    .foregroundStyle(Color(.textBase))
                                    .padding(.bottom, 10)
                            }
                            .onTapGesture {
                                viewModel.checkout("\(viewModel.total)", number, context: context)
                            }
                            
                            if number < 3 || viewModel.getCheckoutType() == 2 {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical, 10)
                
                InGameStatsBar(viewModel: viewModel)
                    .padding(.horizontal)
                                
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
                    .padding(.vertical, 10)
                
                CommonScoresPad(viewModel: viewModel)
            }
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
                        viewModel.numberTapWorkItem?.cancel()
                        viewModel.scoreString.removeAll()
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
                    viewModel.setUpData(legs)
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                            .foregroundStyle(Color(.primaryDark))

                        Text("Restart Game")
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

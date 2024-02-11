//
//  ContentView.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI
import SwiftData
import Pow

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
    
    @ObservedObject var viewModel = ScoreViewModel()
        
    @Query(sort: \Leg.average) var legs: [Leg]
        
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                
                ScoreView(viewModel: viewModel, score: viewModel.total)
                
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
                
                InGameStatsBar(viewModel: viewModel, legs: legs.count)
                    .padding(.horizontal)
                
                Spacer()
                
                NumberPad(viewModel: viewModel)
                
                Divider()
                    .overlay(Color(.neutralXdark))
                    .padding(.vertical, 10)
                
                CommonScoresPad(viewModel: viewModel)
            }
            .padding(.bottom)
        }
        .keyboardAvoiding()
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
                    do {
                        try context.delete(model: Leg.self)
                    } catch {
                        print("Failed to delete legs.")
                    }
                    viewModel.resetStats()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                            .foregroundStyle(Color(.primaryDark))
                        
                        Text("Reset Stats")
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
    .navigationViewStyle(.stack)
}

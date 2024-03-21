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
        GeometryReader { proxy in
            ScrollView {
                VStack (spacing: 0) {
                    
                    ScoreView(viewModel: viewModel, score: viewModel.total)
                    .changeEffect(
                        .rise(origin: UnitPoint(x: 0.5, y: 0.15)) {
                            if viewModel.undoingScore {
                                EmptyView()
                            } else {
                                Text(viewModel.scoreHistory.last ?? "")
                                    .foregroundStyle(viewModel.scoreHistory.last ?? "0" == "180" ? Color(.primaryDark) : Color(.textLight))
                                    .font(.customSemiBold(
                                        Double(viewModel.scoreHistory.last ?? "0") ?? 0 > 20 ? (((viewModel.scoreHistory.last ?? "400").CGFloatValue()?.squareRoot() ?? 20) * 4) : 18
                                    ))
                            }
                        }, value: viewModel.total
                    )
                    
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
                    
                    Button {
                        viewModel.showStatsSheet = true
                    } label: {
                        InGameStatsBar(viewModel: viewModel, legs: legs.count)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    NumberPad(viewModel: viewModel)
                    
                    Divider()
                        .overlay(Color(.neutralXdark))
                        .padding(.vertical, 10)
                    
                    CommonScoresPad(viewModel: viewModel)
                }
                .frame(minHeight: proxy.size.height)
            }
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
                Text("")
            }
        }
        .sheet(isPresented: $viewModel.showStatsSheet) {
            NavigationView {
                StatsMenuView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, CommonScorePad.self, configurations: config)

        for i in 1..<4 {
            let leg = Leg(gameType: ._501, scores: ["100", "140", "100", "81", "60", "20"], average: 83.5, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
            container.mainContext.insert(leg)
        }

        return NavigationView {
                    ContentView()
                }
                .navigationViewStyle(.stack)
                .modelContainer(container)
}

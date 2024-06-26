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
    @AppStorage(UserDefaults.Keys.showingStatsPopover.rawValue) var showingStatsPopover: Bool = true
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
        
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @ObservedObject var viewModel = ScoreViewModel()
        
    @Query(sort: \Leg.date, order: .reverse) var legs: [Leg]

    var body: some View {
        VStack (alignment: .center, spacing: 0) {
            ZStack {
                if !viewModel.checkedOut {
                    ScoreView(viewModel: viewModel, score: viewModel.total)
                } else {
                    ScoreView(viewModel: viewModel, score: viewModel.total)
                }
            }
            
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
                            viewModel.checkout(viewModel.total, number, context: context)
                        }
                        
                        if number < 3 || viewModel.getCheckoutType() == 2 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Button {
                viewModel.showStatsSheet = true
            } label: {
                InGameStatsBar(viewModel: viewModel, legs: legs.count)
                    .padding(.horizontal)
            }
            
            Divider()
                .overlay(Color(.neutralXdark))
                .padding(.vertical, 10)
                            
            NumberPad(viewModel: viewModel)
                .frame(height: height / 3.1)
            
            Divider()
                .overlay(Color(.neutralXdark))
                .padding(.vertical, 10)
            
            CommonScoresPad(viewModel: viewModel)
                .if(showingStatsPopover) { view in
                    view.modifier(TipPopover(showingTip: $showingStatsPopover, parentView: AnyView(
                        Text("Hold down on any quick access score to customize its value.")
                            .multilineTextAlignment(.leading)
                            .font(.bodyRegular)
                            .foregroundColor(Color(.textBase))
                    )))
                }
                .frame(height: height / 5)
        }
        .frame(width: width, height: height)
        .onRotate { _ in
            Task {
                withAnimation {
                    height = UIScreen.main.bounds.height
                    width = UIScreen.main.bounds.width
                }
            }
        }
        .alert("Game shot!", isPresented: $viewModel.showingCheckoutPopup) {
            ForEach(viewModel.getDartsToCheckoutOptions(), id: \.self) { i in
                Button("\(i)") {
                    viewModel.checkout(viewModel.scoreHistory.last, i, context: context)
                }
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
                                .foregroundStyle(Color(.secondaryDark))
                            
                            Text("Undo")
                                .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                                .foregroundStyle(Color(.secondaryDark))
                        }
                    }
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
//                Image(systemName: "gearshape.circle.fill")
//                    .font(.title2Regular)
//                    .foregroundStyle(Color(.primaryDark))
                
                Button {
                    viewModel.showStatsSheet = true
                } label: {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .font(.title2Regular)
                        .foregroundStyle(Color(.secondaryDark))
                }
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

    for leg in Leg.exampleData(4) {
        container.mainContext.insert(leg)
    }

        return NavigationView {
                    ContentView()
                }
                .navigationViewStyle(.stack)
                .modelContainer(container)
}

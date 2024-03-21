//
//  ScoreView.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI
import Pow

struct ScoreView: View {
    @ObservedObject var viewModel: ScoreViewModel
    var score: Int
    
    var body: some View {
        GeometryReader { geo in
            Text("\(score)")
                .font(.custom("Raleway-SemiBold", size: geo.size.height * 1, relativeTo: .largeTitle))
                .frame(maxWidth: .infinity)
                .contentTransition(.numericText(countsDown: true))
                .padding(.top, CheckoutNumbers.shared.isCheckoutNumber(score) ? geo.size.height * -0.1645 : geo.size.height * -0.219)
                .changeEffect(.shake(rate: .fast), value: viewModel.scoreIsInvalid)
                .changeEffect(.wiggle(rate: .fast), value: viewModel.scoreIsZero)
                .onTapGesture {
                    print("\(geo.size.height)")
                }
        }
        .changeEffect(
            .rise(origin: UnitPoint(x: 0.5, y: 0.15)) {
                if viewModel.undoingScore {
                    EmptyView()
                } else {
                    if let last = viewModel.scoreHistory.last, last != 0 {
                        Text("\(last)")
                            .foregroundStyle(viewModel.scoreHistory.last ?? 0 == 180 ? Color(.primaryDark) : Color(.textLight))
                            .font(.customSemiBold(
                                (Double(viewModel.scoreHistory.last ?? 0) > 20) ? (CGFloat(integerLiteral: (viewModel.scoreHistory.last ?? 400)).squareRoot()) * 4 : 18
                            ))
                    }
                }
            }, value: viewModel.total
        )
        .transition(.movingParts.poof)
    }
}

#Preview {
    ScoreView(viewModel: ScoreViewModel(), score: 501)
}

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
    let maxFont: CGFloat = 200
    
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .center,spacing: 0) {
            Spacer()
            
            Text("\(score)")
                .font(.custom("Raleway-SemiBold", fixedSize: CheckoutNumbers.shared.isCheckoutNumber(score) ? height / 5.37 : height / 4.2))
                .contentTransition(.numericText(countsDown: true))
                .foregroundStyle(Color(.textBase))
                .padding(.top, CheckoutNumbers.shared.isCheckoutNumber(score) ? (height / 4) * -0.1645 : (height / 4) * -0.219)
                .changeEffect(.shake(rate: .fast), value: viewModel.scoreIsInvalid)
                .changeEffect(.wiggle(rate: .fast), value: viewModel.scoreIsZero)
            
            Spacer()
        }
        .onRotate { _ in
            Task {
                withAnimation {
                    height = UIScreen.main.bounds.height
                    width = UIScreen.main.bounds.width
                }
            }
        }
        .changeEffect(
            .rise(origin: UnitPoint(x: 0.5, y: 0.15)) {
                if viewModel.undoingScore {
                    EmptyView()
                } else {
                    if let last = viewModel.scoreHistory.last, last != 0 {
                        Text("\(last)")
                            .foregroundStyle(Color(.neutralXlight))
                            .glow(color: Color(.primaryDark), radius: 3)
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
        .frame(maxHeight: .infinity)
        .background(Color(.neutralXlight))
}

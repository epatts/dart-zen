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
    }
}

#Preview {
    ScoreView(viewModel: ScoreViewModel(), score: 501)
}

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
        Text("\(score)")
            .font(Theme.Fonts.ralewaySemiBold(CheckoutNumbers.shared.isCheckoutNumber(score) ? 137 : 180, .largeTitle))
            .frame(maxWidth: .infinity)
            .contentTransition(.numericText(countsDown: true))
            .padding(.top, CheckoutNumbers.shared.isCheckoutNumber(score) ? -30 : -40)
            .changeEffect(.shake(rate: .fast), value: viewModel.scoreIsInvalid)
    }
}

#Preview {
    ScoreView(viewModel: ScoreViewModel(), score: 501)
}

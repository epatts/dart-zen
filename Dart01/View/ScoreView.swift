//
//  ScoreView.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct ScoreView: View {
    var score: Int
    
    var body: some View {
        Text("\(score)")
            .font(Theme.Fonts.ralewaySemiBold(CheckoutNumbers.shared.isCheckoutNumber(score) ? 150 : 180, .largeTitle))
            .frame(maxWidth: .infinity)
            .contentTransition(.numericText(countsDown: true))
            .padding(.top, CheckoutNumbers.shared.isCheckoutNumber(score) ? -30 : -40)
    }
}

#Preview {
    ScoreView(score: 501)
}

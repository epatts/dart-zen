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
            .font(Theme.Fonts.ralewaySemiBold(180, .largeTitle))
            .frame(maxWidth: .infinity)
            .contentTransition(.numericText(countsDown: true))
            .padding(.top, -40)
    }
}

#Preview {
    ScoreView(score: 501)
}

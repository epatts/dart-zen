//
//  CommonScoresPad.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct CommonScoresPad: View {
    @ObservedObject var viewModel: ScoreViewModel
    
    let commonScores = ["26", "41", "45", "60", "81", "85", "100", "121", "125", "133", "140", "180"]
    
    let commonScoreColumns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        LazyVGrid(columns: commonScoreColumns, alignment: .center, spacing: 2) {
            ForEach(commonScores, id: \.self) { number in
                Text(number)
                    .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .padding(14)
                    .foregroundStyle(Color(.textBase))
                    .background(Color(.neutralLight))
                    .onTapGesture {
                        viewModel.handleScore(number)
                        viewModel.numberTapWorkItem?.cancel()
                        viewModel.scoreString.removeAll()
                    }
            }
        }
    }
}

#Preview {
    CommonScoresPad(viewModel: ScoreViewModel())
}
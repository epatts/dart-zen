//
//  CommonScoresPad.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct CommonScoresPad: View {
    var viewModel: ScoreViewModel
    
    let commonScores = ["26", "41", "45", "60", "81", "85", "100", "121", "125", "133", "140", "180"]
    
    let commonScoreColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: commonScoreColumns, alignment: .center, spacing: 10) {
            ForEach(commonScores, id: \.self) { number in
                Text(number)
                    .font(Theme.Fonts.ralewaySemiBold(.body, .body))
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .padding(10)
                    .foregroundStyle(Color(.textBase))
                    .background(Color(.neutralLight))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .onTapGesture {
                        viewModel.handleScore(number)
                    }
            }
        }
    }
}

#Preview {
    CommonScoresPad(viewModel: ScoreViewModel())
}

//
//  CommonScoresPad.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI
import SwiftData

struct CommonScoresPad: View {
    @ObservedObject var viewModel: ScoreViewModel
    
    @Query var commonScorePads: [CommonScorePad]
    
    var body: some View {
        VStack (spacing: 2) {
            ForEach(0...2, id: \.self) { row in
                HStack (spacing: 2) {
                    ForEach(viewModel.commonScores[(row * 4)...(row * 4 + 3)], id: \.self) { score in
                        EditableNumber(viewModel: viewModel, lastNumber: score.scoreString, score: score)
                    }
                }
            }
        }
        .onAppear {
            viewModel.setUpCommonScores(commonScorePads)
        }
    }
}

#Preview {
    CommonScoresPad(viewModel: ScoreViewModel())
}

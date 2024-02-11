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
        VStack (spacing: 2) {
            ForEach(0...2, id: \.self) { row in
                HStack (spacing: 2) {
                    ForEach(commonScores[(row * 4)...(row * 4 + 3)], id: \.self) { number in
                        EditableNumber(viewModel: viewModel, lastNumber: number, number: number)
                    }
                }
            }
        }
    }
}

#Preview {
    CommonScoresPad(viewModel: ScoreViewModel())
}

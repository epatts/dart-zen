//
//  InGameStatsBar.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct InGameStatsBar: View {
    @ObservedObject var viewModel: ScoreViewModel

    var body: some View {
        HStack {
            Text("Last: \(viewModel.scoreHistory.last ?? "-")")
                .font(Theme.Fonts.ralewaySemiBold(.body, .body))
            
            Spacer()
            
            Text("Darts thrown: \(viewModel.scoreHistory.count * 3)")
                .font(Theme.Fonts.ralewaySemiBold(.body, .body))
            
            Spacer()
            
            if !viewModel.scoreHistory.isEmpty || viewModel.totalDartsThrown != 0 {
                Text("Avg: \(viewModel.overallAverage, specifier: "%.2f")")
                    .font(Theme.Fonts.ralewaySemiBold(.body, .body))
            } else {
                Text("Avg: -")
                    .font(Theme.Fonts.ralewaySemiBold(.body, .body))
            }
        }
    }
}

#Preview {
    InGameStatsBar(viewModel: ScoreViewModel())
}

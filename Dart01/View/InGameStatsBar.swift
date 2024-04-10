//
//  InGameStatsBar.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI
import SwiftData

struct InGameStatsBar: View {
    @ObservedObject var viewModel: ScoreViewModel
    var legs: Int = 0

    var body: some View {
        HStack (alignment: .top) {
            VStack (alignment: .trailing, spacing: 5) {
                if let last = viewModel.scoreHistory.last {
                    Text("Last: \(last)")
                        .font(.bodySemiBold)
                } else {
                    Text("Last: -")
                        .font(.bodySemiBold)
                }
                
                Text("# Legs: \(legs)")
                    .font(.bodySemiBold)
            }
            
            Spacer()
            
            VStack (alignment: .center, spacing: 5) {
                Text("\(kDartsThrown): \(viewModel.scoreHistory.count * 3)")
                    .font(.bodySemiBold)
                
                HStack {
                    Text(" ")
                        .font(.bodySemiBold)
                    
                    Text(viewModel.scoreString)
                        .font(.bodySemiBold)
                }
            }
            
            Spacer()
            
            VStack (alignment: .trailing, spacing: 5) {
                Text("Avg: \(viewModel.overallAverage, specifier: "%.2f")")
                    .font(.bodySemiBold)
                
                Text("1st 9: \(viewModel.first9Average, specifier: "%.2f")")
                    .font(.bodySemiBold)
            }
        }
        .foregroundStyle(.textBase)
    }
}

#Preview {
    InGameStatsBar(viewModel: ScoreViewModel())
        .padding(.medium)
}

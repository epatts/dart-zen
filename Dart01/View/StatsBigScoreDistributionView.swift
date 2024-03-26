//
//  StatsBigScoreDistributionView.swift
//  Dart01
//
//  Created by Eric Patterson on 3/26/24.
//

import SwiftUI

struct StatsBigScoreDistributionView: View {
    @ObservedObject var viewModel: ScoreViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: .extraSmall) {
                Text("100+")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
                
                Text("\(viewModel.bigScoreTotals._100s)")
                    .foregroundStyle(Color(.textBase))
                    .font(.bodySemiBold)
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: .extraSmall) {
                Text("120+")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
                
                Text("\(viewModel.bigScoreTotals._120s)")
                    .foregroundStyle(Color(.textBase))
                    .font(.bodySemiBold)
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: .extraSmall) {
                Text("140+")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
                
                Text("\(viewModel.bigScoreTotals._140s)")
                    .foregroundStyle(Color(.textBase))
                    .font(.bodySemiBold)
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: .extraSmall) {
                Text("160+")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
                
                Text("\(viewModel.bigScoreTotals._160s)")
                    .foregroundStyle(Color(.textBase))
                    .font(.bodySemiBold)
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: .extraSmall) {
                Text("180")
                    .foregroundStyle(Color(.textBase))
                    .font(.title3SemiBold)
                
                Text("\(viewModel.bigScoreTotals._180s)")
                    .foregroundStyle(Color(.textBase))
                    .font(.bodySemiBold)
            }
        }
    }
}

#Preview {
    StatsBigScoreDistributionView(viewModel: ScoreViewModel())
}

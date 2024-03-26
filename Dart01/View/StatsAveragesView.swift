//
//  StatsAveragesView.swift
//  Dart01
//
//  Created by Eric Patterson on 3/23/24.
//

import SwiftUI

struct StatsAveragesView: View {
    @ObservedObject var viewModel: ScoreViewModel
    
    var body: some View {
        Group {
            HStack (alignment: .top) {
                VStack (alignment: .leading, spacing: .extraSmall) {
                    Text(" ")
                        .font(.bodySemiBold)
                        .accessibilityHidden(true)
                    
                    Text("Average")
                        .foregroundStyle(Color(.textBase))
                        .font(.bodySemiBold)
                    
                    Text("First 9 Avg")
                        .foregroundStyle(Color(.textBase))
                        .font(.bodySemiBold)
                    
//                    Text("Checkout %")
//                        .foregroundStyle(Color(.textBase))
//                        .font(.bodySemiBold)
                }
                
                HStack (alignment: .top) {
                    Spacer()
                    
                    VStack (alignment: .center, spacing: .extraSmall) {
                        Text("Average")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
                        Text("\(viewModel.overallAverage, specifier: "%.2f")")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
                        Text("\(viewModel.first9Average, specifier: "%.2f")")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
//                        Text("\(viewModel.checkoutAverage * 100, specifier: "%.2f") %")
//                            .foregroundStyle(Color(.textBase))
//                            .font(.bodySemiBold)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .center, spacing: .extraSmall) {
                        Text("Best")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
                        Text("\(viewModel.averageHistory.max() ?? 0, specifier: "%.2f")")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
                        Text("\(viewModel.first9AverageHistory.max() ?? 0, specifier: "%.2f")")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
//                        Text("\((viewModel.checkoutAverageHistory.max() ?? 0) * 100, specifier: "%.2f") %")
//                            .foregroundStyle(Color(.textBase))
//                            .font(.bodySemiBold)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .center, spacing: .extraSmall) {
                        Text("Worst")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
                        Text("\(viewModel.averageHistory.min() ?? 0, specifier: "%.2f")")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
                        Text("\(viewModel.first9AverageHistory.min() ?? 0, specifier: "%.2f")")
                            .foregroundStyle(Color(.textBase))
                            .font(.bodySemiBold)
                        
//                        Text("\((viewModel.checkoutAverageHistory.min() ?? 0) * 100, specifier: "%.2f") %")
//                            .foregroundStyle(Color(.textBase))
//                            .font(.bodySemiBold)
                    }
                }
            }
        }
    }
}

#Preview {
    StatsAveragesView(viewModel: ScoreViewModel())
        .padding(.medium)
}

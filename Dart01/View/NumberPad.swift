//
//  NumberPad.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct NumberPad: View {
    @ObservedObject var viewModel: ScoreViewModel
    
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "←", "0", "Enter"]
        
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 2) {
            ForEach(numbers, id: \.self) { number in
                Text(number)
                    .font(Theme.Fonts.ralewaySemiBold(.title2, .title2))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .padding(20)
                    .foregroundStyle(Color(.textXlight))
                    .background(Color(.primaryDark))
                    .onTapGesture {
                        if number == "←" {
                            if !viewModel.scoreString.isEmpty {
                                viewModel.scoreString.removeLast()
                                if viewModel.scoreString.count > 1 {
                                    viewModel.startTimer()
                                } else if viewModel.scoreString.count == 1 {
                                    viewModel.numberTapWorkItem?.cancel()
                                }
                            }
                        } else if number == "Enter" {
                            viewModel.numberTapWorkItem?.cancel()
                            viewModel.handleScore(viewModel.scoreString)
                            viewModel.scoreString.removeAll()
                        } else {
                            if viewModel.scoreString.count < 3 {
                                viewModel.scoreString.append(number)
                            }
                            viewModel.startTimer()
                        }
                    }
            }
        }
    }
}

#Preview {
    NumberPad(viewModel: ScoreViewModel())
}
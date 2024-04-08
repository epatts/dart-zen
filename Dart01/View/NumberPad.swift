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

    var body: some View {
        VStack (spacing: 10) {
            ForEach(0...3, id: \.self) { row in
                HStack (spacing: 10) {
                    ForEach(numbers[(row * 3)...(row * 3 + 2)], id: \.self) { number in
                        Button {
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
                        } label: {
                            Text(number)
                        }
                        .buttonStyle(NumberPadButtonStyle())
                    }
                }
            }
        }
        .padding(.horizontal, .extraExtraSmall)
    }
}

#Preview {
    NumberPad(viewModel: ScoreViewModel())
        .frame(maxHeight: 300)
        .background(Color(.neutralXlight))
}

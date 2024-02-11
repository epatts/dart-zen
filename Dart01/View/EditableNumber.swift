//
//  EditableNumber.swift
//  Dart01
//
//  Created by Eric Patterson on 2/10/24.
//

import SwiftUI

struct EditableNumber: View {
    @ObservedObject var viewModel: ScoreViewModel
    @State var lastNumber: String
    @State var number: String
    @State var isEditing = false
    
    var body: some View {
        if isEditing {
            Button {} label: {
                TextField("", text: $number)
                    .onSubmit {
                        self.isEditing = false
                        
                        if Int(number) ?? -1 < 0 || Int(number) ?? 181 > 180 {
                            number = lastNumber
                        } else {
                            lastNumber = number
                        }
                    }
                    .keyboardType(.numberPad)
            }
            .buttonStyle(CommonScoreTextFieldStyle())
        } else {
            Button {
                
            } label: {
                Text(number)
            }
            .buttonStyle(CommonScoreButtonStyle())
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                self.isEditing = true
            })
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.handleScore(number)
                viewModel.numberTapWorkItem?.cancel()
                viewModel.scoreString.removeAll()
            })
        }
    }
}

#Preview {
    EditableNumber(viewModel: ScoreViewModel(), lastNumber: "45", number: "45")
}

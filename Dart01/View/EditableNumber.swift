//
//  EditableNumber.swift
//  Dart01
//
//  Created by Eric Patterson on 2/10/24.
//

import SwiftUI
import SwiftData

struct EditableNumber: View {
    @Environment(\.modelContext) var context
    
    @ObservedObject var viewModel: ScoreViewModel
    @State var lastNumber: String
    @State var score: Score
    @State var isEditing = false
    @FocusState var isInputActive: Bool
    
    func submit() {
        self.isEditing = false
        
        if Int(score.scoreString) ?? -1 < 0 || Int(score.scoreString) ?? 181 > 180 || viewModel.commonScores.contains(score) {
            score.scoreString = lastNumber
        } else {
            viewModel.commonScores = viewModel.commonScores.map { $0.scoreString == lastNumber ? Score(scoreString: score.scoreString) : $0 }

            lastNumber = score.scoreString
            
            do {
                try context.delete(model: CommonScorePad.self)
            } catch {
                print("Failed to delete common scores.")
            }
            
            context.insert(CommonScorePad(commonScores: viewModel.commonScores))
        }
    }
    
    var body: some View {
        Button {
            
        } label: {
            Text(score.scoreString)
        }
        .buttonStyle(CommonScoreButtonStyle())
        .simultaneousGesture(LongPressGesture().onEnded { _ in
            self.isEditing = true
        })
        .simultaneousGesture(TapGesture().onEnded {
            viewModel.handleScore(score.scoreString)
            viewModel.numberTapWorkItem?.cancel()
            viewModel.scoreString.removeAll()
        })
        .alert("Enter a new quick access score", isPresented: $isEditing) {
            TextField(score.scoreString, text: $score.scoreString)
                .keyboardType(.numberPad)
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Cancel") {
                            isInputActive = false
                            
                            self.isEditing = false
                            
                            score.scoreString = lastNumber
                        }
                        
                        Button("Done") {
                            submit()
                        }
                        .padding(.leading)
                    }
                }
            Button("OK", action: submit)
        } message: {
            Text("Previous value was \(score.scoreString)")
        }
    }
}

#Preview {
    EditableNumber(viewModel: ScoreViewModel(), lastNumber: "45", score: Score(scoreString: "45"))
}

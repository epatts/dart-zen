//
//  ScoreViewModel.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI

class ScoreViewModel: ObservableObject {
    static let GAME_MODE: Int = 501
    @Published var total = GAME_MODE
    @Published var gamesPlayed: Int = 0
    @Published var scoreHistory: [String] = []
    @Published var averageHistory: [Double] = []
    @Published var totalDartsThrown: Int = 0
    @Published var gameOver = false
    @Published var scoreString = ""
    @Published var overallAverage: Double = 0
        
    var numberTapWorkItem: DispatchWorkItem?

    func newGame() {
        if gameOver {
            gameOver = false
            totalDartsThrown += scoreHistory.count * 3
            gamesPlayed += 1
        } else {
            resetOverallAverage()
        }
        
        scoreHistory.removeAll()
        total = ScoreViewModel.GAME_MODE
    }
    
    func undoLastScore() {
        if let lastScore = Int(scoreHistory.last ?? "0") {
            withAnimation {
                total += lastScore
            }
            
            setOverallAverage(lastScore, adding: false)
        }
        
        scoreHistory.removeLast()
        gameOver = false
    }
    
    func handleScore(_ newScoreString: String) {
        if let score = newScoreString.wordToInteger() {
            calculateNewScore(score)
        } else if let score = Int(newScoreString) {
            calculateNewScore(score)
        }
    }
    
    func setOverallAverage(_ score: Int, adding: Bool = true) {
        let numberOfTotalDartsThrown = totalDartsThrown + scoreHistory.count * 3
        
        if adding {
            overallAverage = (overallAverage + ((Double(score) - overallAverage) / (Double(numberOfTotalDartsThrown) / 3)))
        } else {
            if numberOfTotalDartsThrown == 3 {
                overallAverage = 0
            } else {
                overallAverage = overallAverage + ((overallAverage - Double(score)) / ((Double(numberOfTotalDartsThrown) - 3) / 3))
            }
        }
    }
    
    func resetOverallAverage() {
        overallAverage = Double(gamesPlayed) * Double(ScoreViewModel.GAME_MODE) / Double(totalDartsThrown) * 3
    }
    
    func startTimer() {
        numberTapWorkItem?.cancel()

        numberTapWorkItem = DispatchWorkItem { [weak self] in
            self?.handleScore(self?.scoreString ?? "")
            self?.scoreString.removeAll()
        }

        if let workItem = numberTapWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: workItem)
        }
    }
    
    private func calculateNewScore(_ score: Int) {
        if score >= 0 && score <= 180 {
            if total - score > 1 {
                withAnimation {
                    total -= score
                }
                scoreHistory.append("\(score)")
            } else if total - score == 0 {
                withAnimation {
                    total -= score
                }
                scoreHistory.append("\(score)")
                gameOver = true
            }
            setOverallAverage(score)
        }
    }
}

public extension String {
    func wordToInteger() -> Int? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        return  numberFormatter.number(from: self.lowercased()) as? Int
    }
}

struct Fixtures {
    var scoreViewModel = ScoreViewModel()
    
    func getScoreViewModel() -> ScoreViewModel {
        scoreViewModel.total = 188
        scoreViewModel.scoreHistory = ["45", "52", "121", "55", "40"]
        
        return scoreViewModel
    }
}

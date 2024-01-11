//
//  ScoreViewModel.swift
//  Dart01
//
//  Created by Eric Patterson on 12/29/23.
//

import SwiftUI
import SwiftData

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
    @Published var numDartsUsedForCheckout: Int = 3
    
    @Published var showingCheckoutPopup = false
            
    var numberTapWorkItem: DispatchWorkItem?
    
    func updateContext(context: ModelContext) {
        context.insert(Leg(gameType: ._501, scores: scoreHistory, checkoutScore: scoreHistory.last, average: overallAverage, numDarts: totalDartsThrown, dartsAtDouble: 3, completed: true))
    }

    func newGame() {
        if gameOver {
            gameOver = false
            totalDartsThrown += (scoreHistory.count - 1) * 3 + numDartsUsedForCheckout
            gamesPlayed += 1
        } else {
            resetOverallAverage()
        }
        
        scoreHistory.removeAll()
        total = ScoreViewModel.GAME_MODE
    }
    
    func checkout(_ score: String?, _ numDarts: Int) {
        setOverallAverage(Int(score ?? "0") ?? 0, dartsThrownOnTurn: numDarts)
        numDartsUsedForCheckout = numDarts
        gameOver = true
        newGame()
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
    
    func setOverallAverage(_ score: Int, adding: Bool = true, dartsThrownOnTurn: Int = 3) {
        let numberOfTotalDartsThrown = totalDartsThrown + (scoreHistory.count - 1) * 3 + dartsThrownOnTurn
        
        if adding {
            overallAverage = overallAverage + (((Double(score) * (3 / Double(dartsThrownOnTurn))) - overallAverage) / (Double(numberOfTotalDartsThrown) / Double(dartsThrownOnTurn)))
        } else {
            if numberOfTotalDartsThrown == 3 {
                overallAverage = 0
            } else {
                overallAverage = overallAverage + ((overallAverage - Double(score)) / ((Double(numberOfTotalDartsThrown) - 3) / 3))
            }
        }
    }
    
    func resetOverallAverage() {
        if totalDartsThrown > 0 {
            overallAverage = Double(gamesPlayed) * Double(ScoreViewModel.GAME_MODE) / Double(totalDartsThrown) * 3
        }
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
                setOverallAverage(score)
            } else if total - score == 0 {
                withAnimation {
                    total -= score
                }
                scoreHistory.append("\(score)")
                showingCheckoutPopup = true
            }
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

//struct Fixtures {
//    var scoreViewModel = ScoreViewModel()
//    
//    func getScoreViewModel() -> ScoreViewModel {
//        scoreViewModel.total = 188
//        scoreViewModel.scoreHistory = ["45", "52", "121", "55", "40"]
//        
//        return scoreViewModel
//    }
//}

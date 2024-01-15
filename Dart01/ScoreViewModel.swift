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
    @Published var scoreString = ""
    @Published var overallAverage: Double = 0
    @Published var showingCheckoutPopup = false
    @Published var scoreIsInvalid = false
            
    var numberTapWorkItem: DispatchWorkItem?
    
    func setUpData(_ legs: [Leg]) {
        var totalScore: Int = 0
        var totalDarts: Int = 0
        
        if !legs.isEmpty {
            for leg in legs {
                totalScore += leg.gameType.rawValue
                totalDarts += leg.numDarts
            }
        }
        
        totalDartsThrown = totalDarts
        overallAverage = totalDarts == 0 ? 0 : Double(totalScore) / Double(totalDarts) * 3
        
        total = ScoreViewModel.GAME_MODE
        scoreHistory.removeAll()
    }
    
    func checkout(_ score: String?, _ numDarts: Int, context: ModelContext) {
        withAnimation {
            total -= total
        }
        scoreHistory.append("\(total)")
        
        let dartsThrown = (scoreHistory.count - 1) * 3 + numDarts
        
        setOverallAverage(Int(score ?? "0") ?? 0, dartsThrownOnTurn: numDarts)
        
        context.insert(Leg(gameType: ._501, scores: scoreHistory, checkoutScore: scoreHistory.last, average: Double(total) / Double(dartsThrown) * 3, numDarts: dartsThrown, dartsAtDouble: 3, completed: true))
        
        totalDartsThrown += dartsThrown
        
        scoreHistory.removeAll()
        
        total = ScoreViewModel.GAME_MODE
    }
    
    func getCheckoutType() -> Int {
        if CheckoutNumbers.shared.isOneDartCheckout(total) {
            return 1
        } else if CheckoutNumbers.shared.isTwoDartCheckout(total) {
            return 2
        } else {
            return 3
        }
    }
    
    func undoLastScore() {
        if let lastScore = Int(scoreHistory.last ?? "0") {
            withAnimation {
                total += lastScore
            }
            
            setOverallAverage(lastScore, adding: false)
        }
        
        scoreHistory.removeLast()
    }
    
    func handleScore(_ newScoreString: String) {
        if let score = Int(newScoreString) {
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
            } else {
                scoreIsInvalid.toggle()
            }
        } else {
            scoreIsInvalid.toggle()
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

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
    @Published var scoreHistory: [Int] = []
    @Published var averageHistory: [Double] = []
    @Published var totalDartsThrown: Int = 0
    @Published var scoreString = ""
    @Published var overallAverage: Double = 0
    @Published var first9Average: Double = 0
    @Published var first9AverageHistory: [Double] = []
    @Published var showingCheckoutPopup = false
    @Published var scoreIsInvalid = false
    @Published var scoreIsZero = false
    @Published var legsPlayed: Int = 0
    @Published var showStatsSheet = false
    @Published var undoingScore = false
    @Published var checkedOut = false
    @Published var bigScoreTotals = BigScoreTotals()
    
    @Published var commonScores = [
        Score(scoreString: "26"),
        Score(scoreString: "41"),
        Score(scoreString: "45"),
        Score(scoreString: "60"),
        Score(scoreString: "81"),
        Score(scoreString: "85"),
        Score(scoreString: "100"),
        Score(scoreString: "121"),
        Score(scoreString: "125"),
        Score(scoreString: "133"),
        Score(scoreString: "140"),
        Score(scoreString: "180")
    ]
            
    var numberTapWorkItem: DispatchWorkItem?
    
    func setUpData(_ legs: [Leg]) {
        var totalScore: Int = 0
        var totalDarts: Int = 0
        var total9DartScore: Int = 0
        
        if !legs.isEmpty {
            for leg in legs {
                totalScore += leg.gameType.rawValue
                totalDarts += leg.numDarts
                legsPlayed += 1
                
                for score in leg.scores.prefix(3) {
                    total9DartScore += score
                    bigScoreTotals.inputScore(score)
                }
                
                for score in leg.scores {
                    bigScoreTotals.inputScore(score)
                }
                
                averageHistory.append(leg.average)
                first9AverageHistory.append(Double(leg.scores.prefix(3).reduce(0, +)) / 3)
            }
        }
        
        totalDartsThrown = totalDarts
        overallAverage = totalDarts == 0 ? 0 : Double(totalScore) / Double(totalDarts) * 3
        first9Average = legsPlayed == 0 ? 0 : Double(total9DartScore) / Double(legsPlayed * 9) * 3
        
        total = ScoreViewModel.GAME_MODE
        scoreHistory.removeAll()
    }
    
    func setUpCommonScores(_ scorePads: [CommonScorePad]) {
        if !scorePads.isEmpty, let scores = scorePads.last {
            commonScores = scores.commonScores
        }
    }
    
    func resetStats() {
        overallAverage = 0
        first9Average = 0
        legsPlayed = 0
        scoreHistory.removeAll()
        scoreString.removeAll()
        numberTapWorkItem?.cancel()
        total = ScoreViewModel.GAME_MODE
        totalDartsThrown = 0
        averageHistory.removeAll()
        first9AverageHistory.removeAll()
        bigScoreTotals.reset()
    }
    
    func getFirst9Average() -> Double {
        var total: Double = 0
        
        for score in scoreHistory.prefix(3) {
            total += Double(score)
        }
        
        return total / 3
    }
    
    func checkout(_ score: Int?, _ numDarts: Int, context: ModelContext) {
        scoreHistory.append(score ?? 0)

        withAnimation {
            checkedOut.toggle()
            total -= total
        }
        
        if scoreHistory.count < 4 {
            setFirst9Average(score ?? 0, dartsThrownOnTurn: numDarts)
        }
        
        let dartsThrown = (scoreHistory.count - 1) * 3 + numDarts
        
        setOverallAverage(score ?? 0, dartsThrownOnTurn: numDarts)
        
        let gameAverage = Double(ScoreViewModel.GAME_MODE) / Double(dartsThrown) * 3
        
        context.insert(Leg(gameType: ._501, scores: scoreHistory, checkoutScore: scoreHistory.last, average: gameAverage, numDarts: dartsThrown, dartsAtDouble: 3, completed: true, date: Date.now))
        
        averageHistory.append(gameAverage)
        first9AverageHistory.append(getFirst9Average())
        
        legsPlayed += 1
        
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
        if let lastScore = scoreHistory.last {
            undoingScore = true
            
            withAnimation {
                total += lastScore
            }
            
            setOverallAverage(lastScore, adding: false)
            
            if scoreHistory.count < 4 {
                setFirst9Average(lastScore, adding: false)
            }
        }
        
        scoreHistory.removeLast()
    }
    
    func handleScore(_ newScoreString: String) {
        if let score = Int(newScoreString) {
            undoingScore = false
            
            calculateNewScore(score)
        } else {
            scoreIsInvalid.toggle()
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
    
    func setFirst9Average(_ score: Int, adding: Bool = true, dartsThrownOnTurn: Int = 3) {
        let numberOfTotalDartsThrown = (legsPlayed * 9) + ((scoreHistory.count < 4 ? scoreHistory.count : 3) - 1) * 3 + dartsThrownOnTurn
        
        if adding {
            first9Average = first9Average + (((Double(score) * (3 / Double(dartsThrownOnTurn))) - first9Average) / (Double(numberOfTotalDartsThrown) / Double(dartsThrownOnTurn)))
        } else {
            if numberOfTotalDartsThrown == 3 {
                first9Average = 0
            } else {
                first9Average = first9Average + ((first9Average - Double(score)) / ((Double(numberOfTotalDartsThrown) - 3) / 3))
            }
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
                scoreHistory.append(score)
                setOverallAverage(score)
                
                if scoreHistory.count < 4 {
                    setFirst9Average(score)
                }
                
                if score == 0 {
                    scoreIsZero.toggle()
                }
                
                bigScoreTotals.inputScore(score)
            } else if total - score == 0 {
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

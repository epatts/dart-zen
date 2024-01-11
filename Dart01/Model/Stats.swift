//
//  Stats.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI
import SwiftData

@Model
class Leg {
    var gameType: GameType
    var scores: [String]
    var checkoutScore: String?
    var average: Double
    var numDarts: Int
    var dartsAtDouble: Int
    var completed: Bool = true
    
    init(gameType: GameType, scores: [String], checkoutScore: String? = nil, average: Double, numDarts: Int, dartsAtDouble: Int, completed: Bool) {
        self.gameType = gameType
        self.scores = scores
        self.checkoutScore = checkoutScore
        self.average = average
        self.numDarts = numDarts
        self.dartsAtDouble = dartsAtDouble
        self.completed = completed
    }
}

enum GameType: Int, CaseIterable, Codable {
    case _501 = 501
    case _301 = 301
}

struct Checkout: Codable {
    var score: Int
    var numDarts: Int
}

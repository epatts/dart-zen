//
//  Game.swift
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
    
    init(gameType: GameType, scores: [String], checkoutScore: String? = nil, average: Double) {
        self.gameType = gameType
        self.scores = scores
        self.checkoutScore = checkoutScore
        self.average = average
    }
}

struct Game: Identifiable, Codable, Equatable {
    var id = UUID()
    
    var gameType: GameType
    var scores: [String]
    var checkoutScore: String?
    var average: Double
}

enum GameType: Int, CaseIterable, Identifiable, Codable {
    var id: Self {
        return self
    }
    
    case _501 = 501
    case _301 = 301
}

struct Checkout: Identifiable, Codable {
    var id = UUID()
    
    var score: Int
    var numDarts: Int
}

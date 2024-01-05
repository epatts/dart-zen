//
//  Game.swift
//  Dart01
//
//  Created by Eric Patterson on 1/5/24.
//

import SwiftUI

struct Game: Identifiable, Codable {
    var id = UUID()
    
    var gameType: GameType
    var scores: [Int]
    var checkoutScore: Int
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

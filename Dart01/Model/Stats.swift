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
    var legNumber: Int
    var gameType: GameType
    var scores: [Int]
    var checkoutScore: Int?
    var average: Double
    var numDarts: Int
    var dartsAtDouble: Int
    var completed: Bool = true
    var date: Date?
    
    init(legNumber: Int, gameType: GameType, scores: [Int], checkoutScore: Int? = nil, average: Double, numDarts: Int, dartsAtDouble: Int, completed: Bool, date: Date? = nil) {
        self.legNumber = legNumber
        self.gameType = gameType
        self.scores = scores
        self.checkoutScore = checkoutScore
        self.average = average
        self.numDarts = numDarts
        self.dartsAtDouble = dartsAtDouble
        self.completed = completed
        self.date = date
    }
    
    static func exampleData(_ numberOfLegs: Int = 10) -> [Leg] {
        var legs = [Leg]()
        
        for i in 1 ..< numberOfLegs + 1 {
            legs.append(
                Leg(
                    legNumber: i,
                    gameType: ._501,
                    scores: [
                        Int.random(in: 26..<140),
                        Int.random(in: 26..<140),
                        Int.random(in: 26..<140),
                        Int.random(in: 26..<140),
                        Int.random(in: 26..<140),
                        Int.random(in: 26..<140)
                    ],
                    average: Double.random(in: 40..<70),
                    numDarts: Int.random(in: 9..<24),
                    dartsAtDouble: 3,
                    completed: true,
                    date: Date.now
                )
            )
        }
        
        return legs
    }
}

@Model
class CommonScorePad {
    var commonScores: [Score]
    
    init(commonScores: [Score]) {
        self.commonScores = commonScores
    }
}

struct BigScoreTotals {
    var _100s: Int = 0
    var _120s: Int = 0
    var _140s: Int = 0
    var _160s: Int = 0
    var _180s: Int = 0
    
    mutating func inputScore(_ score: Int) {
        if score == 180 {
            _180s += 1
        } else if score >= 100 && score < 120 {
            _100s += 1
        } else if score >= 120 && score < 140 {
            _120s += 1
        } else if score >= 140 && score < 160 {
            _140s += 1
        } else if score >= 160 && score < 180 {
            _160s += 1
        }
    }
    
    mutating func reset() {
        _100s = 0
        _120s = 0
        _140s = 0
        _160s = 0
        _180s = 0
    }
}

struct Score: Codable, Hashable {
    var scoreString: String
}

enum GameType: Int, CaseIterable, Codable {
    case _501 = 501
    case _301 = 301
}

struct Checkout: Codable {
    var score: Int
    var numDarts: Int
}

class CheckoutNumbers {
    static let shared = CheckoutNumbers()
    private let checkoutNumbers: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "160", "161", "164", "167", "170"]
    
    private let oneDartCheckouts: [String] = ["2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32", "34", "36", "38", "40", "50"]
    
    private let twoDartCheckouts: [String] = ["3", "5", "7", "9", "11", "13", "15", "17", "19", "21", "23", "25", "27", "29", "31", "33", "35", "37", "39", "41", "42", "43", "44", "45", "46", "47", "48", "49", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "100", "101", "104", "107", "110"]
    
    private let threeDartCheckouts: [String] = ["99", "102", "103", "105", "106", "108", "109", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "160", "161", "164", "167", "170"]

    
    private init() { }
    
    func isCheckoutNumber(_ number: Int) -> Bool {
        checkoutNumbers.contains("\(number)")
    }
    
    func isOneDartCheckout(_ number: Int) -> Bool {
        oneDartCheckouts.contains("\(number)")
    }
    
    func isTwoDartCheckout(_ number: Int) -> Bool {
        twoDartCheckouts.contains("\(number)")
    }
    
    func isThreeDartCheckout(_ number: Int) -> Bool {
        threeDartCheckouts.contains("\(number)")
    }
}

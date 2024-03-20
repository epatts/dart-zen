//
//  LegStatsDetailView.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI
import SwiftData

struct LegStatsDetailView: View {
    var leg: Leg
    
    func getFirst9Average() -> Double {
        var total: Double = 0
        
        for score in leg.scores.prefix(3) {
            total += Double(score) ?? 0
        }
        
        return total / 3
    }
    
    var body: some View {
        VStack {
            
            Form {
                Section("Statistics") {
                    LabeledContent("Number of darts", value: "\(leg.numDarts)")
                                                            
                    LabeledContent("3-Dart Average", value: leg.average, format: .number.precision(.fractionLength(2)))
                    
                    LabeledContent("First 9 Average", value: getFirst9Average(), format: .number.precision(.fractionLength(2)))
                }
                
                Section("Checkout") {
                    if let last = leg.scores.last {
                        LabeledContent("Checkout Score", value: "\(last)")
                    }
                    
                    
                    LabeledContent("Darts at Double", value: leg.dartsAtDouble, format: .number)
                                        
                    LabeledContent("Checkout %", value: 1 / Double(leg.dartsAtDouble), format: .percent.precision(.fractionLength(1)))
                }
                
                Section("Scores") {
                    ForEach(leg.scores, id: \.self) { score in
                        Text(score)
                            .listRowBackground(Color(.neutralXxlight))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .background(Color(.neutralXlight))
        .backButtonWithTitleNavBarStyle(title: "\(leg.gameType.rawValue) Leg")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, configurations: config)

    let leg = Leg(gameType: ._501, scores: ["100", "140", "100", "81", "60", "20"], average: 83.50, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
    
    let leg2 = Leg(gameType: ._501, scores: ["100", "140", "100", "81", "60", "20"], average: 93.94, numDarts: 16, dartsAtDouble: 1, completed: true, date: Date.distantPast)
    
    return NavigationView {
            LegStatsDetailView(leg: leg)
    }
        .modelContainer(container)
}

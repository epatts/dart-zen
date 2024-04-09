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
            total += Double(score) 
        }
        
        return total / 3
    }
    
    var body: some View {
        VStack {
            
            Form {
                Group {
                    Section("Statistics") {
                        LabeledContent("Number of darts", value: "\(leg.numDarts)")
                        
                        LabeledContent("3-Dart Average", value: leg.average, format: .number.precision(.fractionLength(2)))
                        
                        LabeledContent("First 9 Average", value: getFirst9Average(), format: .number.precision(.fractionLength(2)))
                    }
                    
                    //                Section("Checkout") {
                    //                    if let last = leg.scores.last {
                    //                        LabeledContent("Checkout Score", value: "\(last)")
                    //                    }
                    //
                    //
                    //                    LabeledContent("Darts at Double", value: leg.dartsAtDouble, format: .number)
                    //
                    //                    LabeledContent("Checkout %", value: 1 / Double(leg.dartsAtDouble), format: .percent.precision(.fractionLength(1)))
                    //                }
                    
                    Section("Scores") {
                        ForEach(leg.scores, id: \.self) { score in
                            Text("\(score)")
                        }
                    }
                    
                    if let date = leg.date {
                        Section() {
                            LabeledContent("Date", value: "\(date.formatted())")
                        }
                    }
                }
                .listRowBackground(Color(.neutralDark))
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .background(Color(.neutralXlight))
        .backButtonWithTitleNavBarStyle(title: "Leg Statistics")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, configurations: config)

    let leg = Leg(legNumber: 1, gameType: ._501, scores: [100, 140, 100, 81, 60, 20], average: 83.50, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
        
    return NavigationView {
            LegStatsDetailView(leg: leg)
    }
        .modelContainer(container)
}

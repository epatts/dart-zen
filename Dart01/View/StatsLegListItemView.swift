//
//  StatsLegListItemView.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI
import SwiftData

struct StatsLegListItemView: View {
    var leg: Leg
    
    var body: some View {
        VStack (alignment: .center, spacing: .extraSmall) {
            
            Text("\(leg.gameType.rawValue) Leg")
                .font(.title2Bold)
            
            if let legDate = leg.date {
                Text("\(legDate.formatted())")
                    .font(.bodyRegular)
            }
            
            HStack {
                VStack {
                    Text("Darts")
                        .font(.bodySemiBold)
                    
                    Text("\(leg.numDarts)")
                        .font(.bodyRegular)
                }
                
                Spacer()
                
                VStack {
                    Text("Checkout")
                        .font(.bodySemiBold)
                    
                    Text("\(1 / Double(leg.dartsAtDouble) * 100, specifier: "%.0f") %")
                        .font(.bodyRegular)
                }
                
                Spacer()
                
                VStack {
                    Text("Average")
                        .font(.bodySemiBold)
                    
                    Text("\(leg.average, specifier: "%.2f")")
                        .font(.bodyRegular)
                }
            }
            
        }
        .padding(.medium)
        .background(Color(.neutralXxlight))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, configurations: config)

    let leg = Leg(gameType: ._501, scores: ["100, 140, 100, 81, 60, 20"], average: 83.5, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
    
    let leg2 = Leg(gameType: ._501, scores: ["180, 140, 100, 60, 21"], average: 93.94, numDarts: 16, dartsAtDouble: 1, completed: true, date: Date.distantPast)
    
    return VStack (spacing: .medium) {
        StatsLegListItemView(leg: leg)
        
        StatsLegListItemView(leg: leg2)
    }
        .modelContainer(container)
}

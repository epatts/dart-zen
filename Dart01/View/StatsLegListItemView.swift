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
        VStack (alignment: .center, spacing: 0) {
            
            HStack {
                
                VStack (spacing: .extraSmall) {
                    HStack {
                        if let legDate = leg.date {
                            Text("\(legDate.formatted())")
                                .font(.subheadlineRegular)
                        }
                        
                        Spacer()
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
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(.textLight))
                    .font(.bodyRegular)
                    .padding(.leading, .small)
                
            }
            
        }
        .padding(.medium)
        .background(Color(.neutralXxlight))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, configurations: config)

    let leg = Leg(gameType: ._501, scores: ["100", "140", "100", "81", "60", "20"], average: 83.5, numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
        
    return StatsLegListItemView(leg: leg)
        .modelContainer(container)
}
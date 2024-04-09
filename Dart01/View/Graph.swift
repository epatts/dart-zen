//
//  Graph.swift
//  Dart01
//
//  Created by Eric Patterson on 4/8/24.
//

import SwiftUI
import Charts
import SwiftData

struct Graph: View {
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @State var position: PlotPoint?
    
    var data = [46, 0, 55, 167, 59]
    
    var legs = [Leg]()
    
    @State var selectedLeg: Leg?
    
    @State var newData: [PlotPoint] = []
    
    func getAverage() -> Double {
        var total = 0.0
        
        for leg in legs {
            total += leg.average
        }
        
        return total == 0 ? 0 : total / Double(legs.count)
    }
    
    func updateCursorPosition(at: CGPoint, geometry: GeometryProxy, proxy: ChartProxy) {
        guard let plotFrame = proxy.plotFrame else { return }
        
        let origin = geometry[plotFrame].origin
        guard let clickedPosition = proxy.value(atX: at.x - origin.x + .medium, as: Int.self) else { return }
        let firstGreater = legs.lastIndex(where: { $0.legNumber <= clickedPosition })
        
        if let i = firstGreater {
            let index = newData[i].index
            let value = newData[i].value
            position = PlotPoint(index: index, value: value)
            selectedLeg = legs[i]
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            ZStack {
                Chart {
                    ForEach(legs, id: \.self) { leg in
                        
                        let data = PlotPoint.init(index: leg.legNumber, value: leg.average)
                        
                        RuleMark(y: .value("Average", getAverage()))
                            .foregroundStyle(Color(.secondaryDark))
                        
                        LineMark(
                            x: .value("Shape Type", data.index),
                            y: .value("Total Count", data.value)
                        )
                        .foregroundStyle(Color(.primaryDark))
                        
                        PointMark(
                            x: .value("Shape Type", data.index),
                            y: .value("Total Count", data.value)
                        )
                        .foregroundStyle(Color(.primaryDark))
                    }
                    
                    if let position = position {
                        RuleMark(x: .value("Index", position.index))
                            .foregroundStyle(Color(.neutralXdark).opacity(1))
                            .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .minute)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month(.defaultDigits))
                    }
                }
                .chartXScale(domain: 1...legs.count)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(DragGesture()
                                .onChanged { dragLocation in
                                    updateCursorPosition(at: dragLocation.location, geometry: geometry, proxy: proxy)
                                }
                                .onEnded({ _ in
                                    position = nil
                                    selectedLeg = nil
                                }))
                                .onTapGesture { location in
                                    updateCursorPosition(at: location, geometry: geometry, proxy: proxy)
                                    print("\(location)")
                                }
                    }
                }
                
                if let leg = selectedLeg {
                    VStack {
                        Spacer()
                        
                        HStack {
                            NavigationLink {
                                LegStatsDetailView(leg: leg)
                            } label: {
                                HStack {
                                    Text("Avg: \(leg.average, specifier: "%.2f")")
                                        .font(.bodyBold)
                                        .foregroundStyle(Color(.textBase))
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.bodyBold)
                                        .foregroundStyle(Color(.textBase))
                                }
                                .padding(.extraSmall)
                                .background(Color(.neutralXlight))
                                .clipShape(Capsule())
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom, .extraExtraSmall)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: height / 5)
        .padding(.medium)
        .onAppear {
            for leg in legs {
                newData.append(PlotPoint(index: leg.legNumber, value: leg.average))
            }
        }
        .background(Color(.neutralDark))
    }
}

struct PlotPoint: Identifiable, Hashable {
    var index: Int
    var value: Double
    var id = UUID()
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Leg.self, CommonScorePad.self, configurations: config)
    
    var legs = [Leg]()

    for i in 1..<20 {
        let leg = Leg(legNumber: i, gameType: ._501, scores: [100, 140, 100, 81, 60, 20], average: Double.random(in: 40..<70), numDarts: 18, dartsAtDouble: 3, completed: true, date: Date.now)
        container.mainContext.insert(leg)
        legs.append(leg)
    }
    
    return Graph(legs: legs)
}

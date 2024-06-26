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
    @Environment(\.modelContext) var context

    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @State var position: PlotPoint?
    @State var showLine = false
    
    @ObservedObject var viewModel: ScoreViewModel
        
    @Query(sort: \Leg.date) var legs: [Leg]
    
    @State var selectedLeg: Leg?
    
    @State var newData: [PlotPoint] = []
    
    func updateCursorPosition(at: CGPoint, geometry: GeometryProxy, proxy: ChartProxy, fromTap: Bool = false) {
        guard let plotFrame = proxy.plotFrame else { return }
        
        let origin = geometry[plotFrame].origin
        guard let clickedPosition = proxy.value(atX: at.x - origin.x + .medium, as: Int.self) else { return }
        let firstGreater = legs.lastIndex(where: { $0.legNumber <= clickedPosition })
        
//        lineDragPosition = at
        
        if let i = firstGreater {
            let index = newData[i].index
            let value = newData[i].value
            if !fromTap {
                showLine = true
            }
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
                        
                        RuleMark(y: .value("Average", viewModel.overallAverage))
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
                        if showLine {
                            RuleMark(x: .value("Index", position.index))
                                .foregroundStyle(Color(.neutralXdark).opacity(0.4))
                        }
                        
                        PointMark(
                            x: .value("", position.index),
                            y: .value("", position.value)
                        )
                        .symbol {
                            ZStack {
                                Circle()
                                    .frame(width: 10)
                                    .foregroundStyle(Color(.neutralXdark))
                                    .glow(color: Color(.neutralXdark), radius: 5)
                                    .opacity(0.5)
                                
                                Circle()
                                    .frame(width: 8)
                                    .foregroundStyle(Color(.neutralXdark))
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .minute)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month(.defaultDigits))
                    }
                }
                .padding(.bottom, .large)
                .chartXScale(domain: 1...legs.count)
                .chartYScale(domain: (viewModel.averageHistory.min() ?? 0) - 10 ... (viewModel.averageHistory.max() ?? 167) + 10)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(DragGesture()
                                .onChanged { dragLocation in
                                    updateCursorPosition(at: dragLocation.location, geometry: geometry, proxy: proxy)
                                }
                                .onEnded({ _ in
                                    showLine = false
                                }))
                                .onTapGesture { location in
                                    updateCursorPosition(at: location, geometry: geometry, proxy: proxy, fromTap: true)
                                }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack (alignment: .bottom) {
                        if let leg = selectedLeg {
                            NavigationLink {
                                LegStatsDetailView(viewModel: viewModel, leg: leg)
                            } label: {
                                HStack (alignment: .bottom) {
                                    Text("Leg: \(leg.average, specifier: "%.2f")")
                                        .font(.subheadlineBold)
                                        .foregroundStyle(Color(.textBase))
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.bodyBold)
                                        .foregroundStyle(Color(.textBase))
                                }
                                .padding(.extraSmall)
                                .background(Color(.neutralDark).opacity(0.7))
                                .clipShape(Capsule())
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "line.diagonal")
                                .font(.title2Bold)
                                .foregroundStyle(Color(.secondaryDark))
                                .rotationEffect(Angle(degrees: 45))
                            
                            Text("\(viewModel.overallAverage, specifier: "%.2f") avg")
                                .font(.subheadlineBold)
                                .foregroundStyle(Color(.textBase))
                        }
                        .padding(.trailing, .extraLarge)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: height / 4)
        .onAppear {
            position = nil
            selectedLeg = nil
            newData.removeAll()
            
            for leg in legs {
                newData.append(PlotPoint(index: leg.legNumber, value: leg.average))
                print("Index: \(leg.legNumber)")
            }
        }
        .background(Color(.neutralXlight))

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
    
    for leg in Leg.exampleData(20) {
        container.mainContext.insert(leg)
    }
    
    return NavigationStack {
        Graph(viewModel: ScoreViewModel())
    }
        .padding(.medium)
        .modelContainer(container)
}

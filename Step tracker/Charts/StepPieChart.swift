//
//  StepPieChart.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-13.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    @State private var rawSelectedChartValue: Double? = 0
    
    
    var chartData: [WeekdayChartData]
    
    var selectedWeekday: WeekdayChartData? {
        guard let rawSelectedChartValue else { return nil }
        var total = 0.0
        return chartData.first {
            total += $0.value
            return rawSelectedChartValue <= total
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Label("Averages", systemImage: "calendar")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.green)
                
                Text("Last 28 days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
         
            Chart {
                ForEach(chartData) { weekDay in
                    SectorMark(angle: .value("Average steps", weekDay.value),
                               innerRadius: .ratio(0.618),
                               outerRadius: selectedWeekday?.date.weekdayInt == weekDay.date.weekdayInt ? 140 : 110,
                               angularInset: 1)
                    .foregroundStyle(.green.gradient)
                    .cornerRadius(6)
                    .opacity(selectedWeekday?.date.weekdayInt == weekDay.date.weekdayInt ? 1.0 : 0.5)
                }
            }.chartAngleSelection(value: $rawSelectedChartValue.animation(.easeInOut))
            .frame(height: 240)
            .chartBackground { proxy in
                GeometryReader { geo in
                    if let plotFrame = proxy.plotFrame {
                        let frame = geo[plotFrame]
                        if let selectedWeekday {
                            VStack {
                                Text(selectedWeekday.date.weekdayTitle)
                                    .font(.title3.bold())
                                    .animation(nil)
                                
                                Text(selectedWeekday.value, format: .number.precision(.fractionLength(0)))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .contentTransition(.numericText())
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.avergageWeekDayCount(for: HealthMetric.mockData))
}

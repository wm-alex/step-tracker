//
//  StepBarChart.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-13.
//

import SwiftUI
import Charts
struct StepBarChart: View {
    
    @State private var rawSelectedDate: Date?
    
    var selectedStat: HealthMetricContext
    
    var chartData: [HealthMetric]
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var averageStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        let totalSteps = chartData.reduce(0) { $0 + $1.value }
        return totalSteps/Double(chartData.count)
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.green)
                        
                        Text("Avg: \(Int(averageStepCount)) steps ")
                            .font(.caption)
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let selectedHealthMetric {
                    RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                        .foregroundStyle(.secondary.opacity(0.5))
                        .offset(y: -10)
                        .annotation(position: .top,
                                    alignment: .center,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart),
                                                              y: .disabled)) { annotationView }
                }
                
                RuleMark(y: .value("Average", averageStepCount))
                    .foregroundStyle(Color.secondary)
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { steps in
                    BarMark(x: .value("Date", steps.date, unit: .day),
                            y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(.green.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == selectedHealthMetric?.date ? 1.0 : 0.3)
                }
            }.frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.3))
                        
                        AxisValueLabel((value.as(Double.self) ??
                                        0).formatted(.number.notation(.compactName)))
                    }
                }
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now,
                 format: .dateTime.weekday(.abbreviated)
                .month(.abbreviated)
                .day())
            .font(.footnote.bold())
            .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.green)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    StepBarChart(selectedStat: .steps, chartData: HealthMetric.mockData)
}

//
//  StepPieChart.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-13.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    
    var chartData: [WeekdayChartData]
    
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
                               angularInset: 1)
                    .foregroundStyle(.green.gradient)
                    .cornerRadius(6)
                }
            }
            .frame(height: 240)
         
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.avergageWeekDayCount(for: HealthMetric.mockData))
}

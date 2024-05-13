//
//  WeekdayChartData.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-13.
//

import Foundation
struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

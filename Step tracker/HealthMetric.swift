//
//  HealthMetric.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

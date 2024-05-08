//
//  HealthKitManager.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import Foundation
import HealthKit
import Observation

@Observable
class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}

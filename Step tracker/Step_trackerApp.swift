//
//  Step_trackerApp.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import SwiftUI

@main
struct Step_trackerApp: App {
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}

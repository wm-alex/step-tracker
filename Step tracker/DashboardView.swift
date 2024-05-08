//
//  DashboardView.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    
    var id: Self { return self }
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager
    
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming: Bool = false
    
    @State private var isShowingPermissionPrimingSheet: Bool = false
    @State private var selectedStat: HealthMetricContext = .steps
    
    private var isSteps: Bool { return selectedStat == .steps }
    
    var averageStepCount: Double {
        guard !hkManager.stepData.isEmpty else { return 0 }
        let totalSteps = hkManager.stepData.reduce(0) { $0 + $1.value }
        return totalSteps/Double(hkManager.stepData.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected State", selection: $selectedStat, content: {
                        ForEach(HealthMetricContext.allCases, content: {
                            Text($0.title)
                        })
                    }).pickerStyle(.segmented)
                    
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
                            
                            RuleMark(y: .value("Average", averageStepCount))
                                .foregroundStyle(Color.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [5]))
                            
                            ForEach(hkManager.stepData) { steps in
                                BarMark(x: .value("Date", steps.date, unit: .day),
                                        y: .value("Steps", steps.value)
                                )
                                .foregroundStyle(.green.gradient)
                            }
                        }.frame(height: 150)
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
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet,
                   onDismiss: {
                // fetch health data
            }, content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })
            
        }.tint(isSteps ? .green : .indigo)
    }
}

#Preview {
    DashboardView().environment(HealthKitManager())
}

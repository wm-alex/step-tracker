//
//  HealthDataListView.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import SwiftUI

struct HealthDataListView: View {
    var metric: HealthMetricContext
    
    
    @State private var isShowingAddData: Bool = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    private var isStepsMetric: Bool {
        return metric == .steps
    }
    
    var body: some View {
        List(0..<28) { i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(10000, format: .number.precision(.fractionLength(isStepsMetric ? 0 : 1)))
            }
        }.navigationTitle(metric.title)
            .sheet(isPresented: $isShowingAddData) {
                addDataView
            }.toolbar {
                Button("Add Data", systemImage: "plus") {
                    isShowingAddData = true
                }
            }
    }
    
    private var addDataView: some View {
        
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(isStepsMetric ? .numberPad : .decimalPad)
                }
                
            }.navigationTitle(metric.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button("Add Data") {
                            //TODO: Add code
                        }
                    })
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button("Dismiss") {
                            isShowingAddData = false
                        }
                    })
                }
        }
    }
    
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
}

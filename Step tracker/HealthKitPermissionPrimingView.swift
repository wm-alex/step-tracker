//
//  HealthKitPermissionPrimingView.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionPrimingView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingHealthKitPermissions: Bool = false
    
    private var description: String = """
    This app displays your step and weight data in interactive charts.\n
    You can also add new step or weight data to Apple Health from this app. Your data is private and secured.
    """
    
    var body: some View {
        VStack(spacing: 130){
            VStack(alignment: .leading, spacing: 12) {
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Integration")
                    .font(.title2)
                    .bold()
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
            Button("Connect Apple Health") {
                isShowingHealthKitPermissions = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }.padding(30)
        .healthDataAccessRequest(store: hkManager.store,
                                     shareTypes: hkManager.types,
                                     readTypes: hkManager.types,
                                     trigger: isShowingHealthKitPermissions,
                                     completion: { result in
                switch result {
                case .success(let success):
                    dismiss()
                case .failure(let failure):
                    //TODO: handle error
                    dismiss()
                }
            })
    }
}

#Preview {
    HealthKitPermissionPrimingView().environment(HealthKitManager())
}

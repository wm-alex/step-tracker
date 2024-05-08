//
//  HealthKitPermissionPrimingView.swift
//  Step tracker
//
//  Created by Alexander Gunnarsson on 2024-05-08.
//

import SwiftUI

struct HealthKitPermissionPrimingView: View {
    
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
                //TODO: Code for apple health integration
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }.padding(30)
    }
}

#Preview {
    HealthKitPermissionPrimingView()
}

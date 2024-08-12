//
//  CustomButton.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/10/24.
//

import SwiftUI

struct CustomButton: View {
    
    let label: String
    let labelColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(backgroundColor)
                Text(label)
                    .foregroundStyle(labelColor)
            }
        })
    }
}

#Preview {
    CustomButton(label: "Text example", labelColor: .white, backgroundColor: .cyan) {
        return
    }
}

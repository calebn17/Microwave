//
//  MicrowaveAppleAssessmentApp.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/10/24.
//

import SwiftUI

@main
struct MicrowaveAppleAssessmentApp: App {
    var body: some Scene {
        WindowGroup {
            MicrowaveView(viewModel: MicrowaveViewModel())
        }
    }
}

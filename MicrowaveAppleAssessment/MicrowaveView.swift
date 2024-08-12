//
//  ContentView.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/10/24.
//

import SwiftUI

struct MicrowaveView: View {
    @ObservedObject var viewModel: MicrowaveViewModel
    
    let auxiliaryButtonEdgeInsets = EdgeInsets(
        top: 10,
        leading: 10,
        bottom: 10,
        trailing: 10
    )
        
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Microwave App")
                .bold()
                .padding()
                .accessibilityLabel("screen-title")
            
            Spacer()
            
            timerView
            formFieldView
            selectPowerPickerView
            startStopButtonView
            auxiliaryButtonView
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .alert(item: $viewModel.alert) { alert in
            switch alert {
            case .invalidTime:
                return invalidTimeAlert
            case .invalidWeight:
                return invalidWeightAlert
            }
        }
    }
    
    var timerView: some View {
        Text(viewModel.shownTime)
            .font(.largeTitle)
            .accessibilityIdentifier("timer-view")
    }
    
    var formFieldView: some View {
        VStack {
            Form() {
                TextField("Enter Time in 00:00 format",
                          text: $viewModel.enteredTimeString
                )
                .accessibilityIdentifier("input-time-field")
                
                TextField(
                    "Enter weight (g)",
                    text: $viewModel.enteredWeightString
                )
                .accessibilityIdentifier("input-weight-field")
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(width: 350, height: 150, alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
    
    var selectPowerPickerView: some View {
        VStack {
            Picker("Select Power Setting", selection: $viewModel.powerSetting) {
                ForEach(1..<11) { level in
                    Text("\(level)")
                        .foregroundStyle(.link)
                        .font(.title)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .background(Color.gray.opacity(0.7))
            .clipShape(.rect(cornerRadius: 20))
            .frame(width: 350 ,height: 100)
            .accessibilityIdentifier("power-level-picker")
        }
    }
        
    //MARK: - Button views
    var startStopButtonView: some View {
        HStack(spacing: 20) {
            CustomButton(
                label: "Start",
                labelColor: .white,
                backgroundColor: .green) {
                    viewModel.startMicrowave()
                }
                .accessibilityIdentifier("start-button")
            
            CustomButton(
                label: "Stop",
                labelColor: .white,
                backgroundColor: .red) {
                    viewModel.stopMicrowave()
                }
                .accessibilityIdentifier("stop-button")
 
            
            CustomButton(
                label: "Clear",
                labelColor: .white,
                backgroundColor: .cyan) {
                    viewModel.clearMicrowaveTimer()
                }
                .accessibilityIdentifier("clear-button")

        }
        .frame(width: 350, height: 100, alignment: .center)
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
    
    var auxiliaryButtonView: some View {
        VStack(spacing: 20) {
            CustomButton(
                label: "Microwave Popcorn",
                labelColor: .white,
                backgroundColor: .yellow) {
                    viewModel.microwavePopcorn()
                }
                .accessibilityIdentifier("microwave-popcorn-button")
            
            CustomButton(
                label: "Defrost by weight",
                labelColor: .white,
                backgroundColor: .blue) {
                    viewModel.defrost(by: .weight)
                }
                .accessibilityIdentifier("defrost-weight-button")
            
            CustomButton(
                label: "Defrost by time",
                labelColor: .white,
                backgroundColor: .blue) {
                    viewModel.defrost(by: .time)
                }
                .accessibilityIdentifier("defrost-time-button")
        }
        .frame(width: 350, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding(auxiliaryButtonEdgeInsets)
    }
    
    //MARK: - Alert views
    
    var invalidTimeAlert: Alert {
        Alert(
            title: Text("Entered time is in the wrong format"),
            message: Text("Please try again"),
            dismissButton: .cancel({
                    viewModel.tappedCancelButton()
                })
        )
    
    }
    
    var invalidWeightAlert: Alert {
        Alert(
            title: Text("Entered weight is in the wrong format (whole numbers only)"),
            message: Text("Please try again"),
            dismissButton: .cancel({
                viewModel.tappedCancelButton()
            })
        )
    }
}

#Preview {
    MicrowaveView(viewModel: MicrowaveViewModel())
}

//
//  CustomTimerMock.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/11/24.
//

@testable import MicrowaveAppleAssessment
import Foundation
import Combine


/// Mock ``CustomTimer`` used for unit tests
final class CustomTimerMock: CustomTimerProtocol {
    var timeLeftSubject = CurrentValueSubject<String, Never>("")
    
    var startTimerCalledCount = 0
    var startTimerCalled: Bool {
        startTimerCalledCount > 0
    }
    
    var stopTimerCalledCount = 0
    var stopTimerCalled: Bool {
        stopTimerCalledCount > 0
    }
    
    var clearTimerCalledCount = 0
    var clearTimerCalled: Bool {
        clearTimerCalledCount > 0
    }
    
    var formatTimeCalledCount = 0
    var formatTimerCalled: Bool {
        formatTimeCalledCount > 0
    }
    
    
    init() {}
    
    func startTimer(enteredTime: TimeInterval) {
        startTimerCalledCount += 1
    }
    
    func stopTimer() {
        stopTimerCalledCount += 1
    }
    
    func clearTimer() {
        clearTimerCalledCount += 1
    }
    
    func formatTime(interval: TimeInterval) -> String {
        formatTimeCalledCount += 1
        return ""
    }
}

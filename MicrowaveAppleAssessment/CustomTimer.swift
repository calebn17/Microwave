//
//  CustomTimer.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/10/24.
//

import Foundation
import Combine

protocol CustomTimerProtocol {
    var timeLeftSubject: CurrentValueSubject<String, Never> { get }
    
    func startTimer(enteredTime: TimeInterval)
    func stopTimer()
    func clearTimer()
    func formatTime(interval: TimeInterval) -> String
}

final class CustomTimer: CustomTimerProtocol {
    
    /// Time that is left
    /// Will be displayed in the view
    private var timeLeft: TimeInterval = 0.0
    
    var timeLeftSubject = CurrentValueSubject<String, Never>("00:00")

    private var timer: AnyCancellable?
    
    
    init() {}
    
    /// Starts the countdown
    func startTimer(enteredTime: TimeInterval) {
        timeLeft = enteredTime
        /// Decrement the `timeLeft` by 1 sec for every second that passes
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }
    
    func stopTimer() {
        guard let timer else { return }
        timer.cancel()
    }
    
    func clearTimer() {
        timeLeft = 0.0
    }
    
    func formatTime(interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK: - Private methods
    
    private func updateTime() {
        guard timeLeft > 0 else {
            stopTimer()
            return
        }
        
        /// No mattter what, send the `timeLeft`
        defer {
            /// Format `timeLeft` into a string with the correct formatting
            /// and sends it to the viewModel.
            timeLeftSubject.send(formatTime(interval: timeLeft))
        }
        
        timeLeft -= 1
    }
}

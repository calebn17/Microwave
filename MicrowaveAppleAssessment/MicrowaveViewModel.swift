//
//  MicrowaveViewModel.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/10/24.
//

import Foundation
import Combine

enum DefrostMethod {
    case weight
    case time
}

enum TimerError: Error {
    case invalidTimeInputString
    case invalidWeightInputString
}

/// All the different types of alerts that will be shown in the View
enum ViewAlert: Identifiable {
    case invalidTime
    case invalidWeight
    
    var id: Int { hashValue }
}

@MainActor /// Ensuring that this viewModel operates on the main thread
final class MicrowaveViewModel: ObservableObject {
    
    /// View Data
    @Published var enteredTimeString: String = ""
    @Published var enteredWeightString: String = ""
    /// String that is shown on the timer in the view
    @Published var shownTime: String = "00:00"
    @Published var powerSetting: Int = 5 // Default power level setting
    /// Observed property that handles the alerts shown in the View
    @Published var alert: ViewAlert? = nil
    /// Bool that shows if the timer is currently counting
    private var isCountingDown: Bool = false
    
    private let microwaveTimer: CustomTimerProtocol
    
    /// Purpose is to be able to use preset time settings
    /// For example, we can this to inject a time input for `microwavePopcorn()` without
    /// actually changing the input text field value.
    private var timeStringCache = "00:00"
    
    /// True if microwave is using a preset timer setting
    private var isUsingPresetTimeSettings: Bool = false
    
    private var subscribers = Set<AnyCancellable>()
    
    init(microwaveTimer: CustomTimerProtocol = CustomTimer()) {
        self.microwaveTimer = microwaveTimer
        bind()
    }
    
    /// Begin observing the `timeLeft` in the ``CustomTimer``
    /// and updates the `shownTime` reactively.
    func bind() {
        microwaveTimer.timeLeftSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeString in
                self?.shownTime = timeString
            }
            .store(in: &subscribers)
    }
    
    func startMicrowave() {
        /// If the Timer is already counting down then do nothing if the start button is pressed
        guard !isCountingDown else { return }
        
        defer {
            /// Ensures that `isUsingPesetTimeSettings` is always reset to `false`.
            isUsingPresetTimeSettings = false
        }
        
        /// If microwave is using a preset time setting, then don't use the textfield entered string,
        /// and instead use the `cachedTimeString`'s preset value.
        /// ex. microwave popcorn
        if !isUsingPresetTimeSettings {
            timeStringCache = enteredTimeString
        }
        
        /// If the time shown is not cleared, then pressing on start will resume the shown time.
        /// This logic doesn't apply if preset time settings are being used.
        if shownTime != "00:00", !isUsingPresetTimeSettings {
            timeStringCache = shownTime
        }
        
        do {
            let enteredTimeInterval = try formatEnteredTimeStringToTimeInterval(timeString: timeStringCache)
            microwaveTimer.startTimer(enteredTime: enteredTimeInterval)
            isCountingDown = true
        }
        catch {
            print(error.localizedDescription)
            alert = .invalidTime
        }
    }
    
    func stopMicrowave() {
        microwaveTimer.stopTimer()
        isCountingDown = false
    }
    
    func clearMicrowaveTimer() {
        stopMicrowave()
        shownTime = "00:00"
        microwaveTimer.clearTimer()
        isCountingDown = false
    }
    
    func defrost(by defrostMethod: DefrostMethod) {
        
        let timeInterval: TimeInterval
        
        switch defrostMethod {
        case .weight:
            guard let enteredWeightInt = Int(enteredWeightString),
                  // A bit arbitrary, but this will keep the total time to under an hour.
                  // Mainly for simplicity of this app.
                  enteredWeightInt < 1201
            else {
                alert = .invalidWeight
                return
            }
            
            isUsingPresetTimeSettings = true
            /// Changes the picker wheel value to 3
            powerSetting = 3 // Arbitrary default value. Lower power level when defrosting food.
            timeInterval = Double(powerSetting * enteredWeightInt)
            timeStringCache = microwaveTimer.formatTime(interval: timeInterval)
            startMicrowave()
            
        case .time:
            do {
                timeInterval = try formatEnteredTimeStringToTimeInterval(timeString: enteredTimeString)
                /// Arbitrary formula
                /// Scales the max and min input time to a scale from 1-10
                /// where the longer the time, the lower the power setting
                /// Decrementing by 1 because the picker is offset by 1 (since the start value is set to `1`)
                powerSetting = Int((10 - ((timeInterval-1)/3659)*9).rounded(.down)) - 1
                startMicrowave()
            }
            catch {
                print(error.localizedDescription)
                alert = .invalidTime
            }
            
        }
    }
    
    func microwavePopcorn() {
        isUsingPresetTimeSettings = true
        timeStringCache = "05:00"
        powerSetting = 7
        startMicrowave()
    }
    
    /// Reset `alert` if user taps cancel from an alert
    func tappedCancelButton() {
        alert = nil
    }
    
    //MARK: - Private methods
    
    /// Formats the input string into a `TimeInterval`
    private func formatEnteredTimeStringToTimeInterval(timeString: String) throws -> TimeInterval  {
        
        /// Ensuring character count is correct,
        /// and more importantly if there is a `:`
        /// before the string is split.
        guard timeString.count == 5,
                timeString.contains(":")
        else {
            throw(TimerError.invalidTimeInputString)
        }
        
        /// Converting `timeString` -> [minutes, seconds]
        let timeComponentsArray = timeString.split(separator: ":")
        
        /// Ensuring that each component only contains positive integers
        guard let minutes = Int(timeComponentsArray[0]),
              let seconds = Int(timeComponentsArray[1]),
              minutes <= 60, minutes >= 0,
              seconds <= 60, seconds >= 0
        else {
            throw(TimerError.invalidTimeInputString)
        }
        
        /// Total time interval calculated
        return TimeInterval(minutes * 60 + seconds)
    }
}

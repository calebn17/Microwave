//
//  MicrowaveAppleAssessmentUITests.swift
//  MicrowaveAppleAssessmentUITests
//
//  Created by Caleb Ngai on 8/10/24.
//

import XCTest

/// UI Tests
final class MicrowaveViewUITests: XCTestCase {

    let app = XCUIApplication()
    
    var sut: MicrowaveViewScreen!
    
    override func setUpWithError() throws {
        sut = MicrowaveViewScreen(app: app)
        app.launch()
    }
    
    //MARK: - Example UI Tests
    
    func test_enterValidTime_pressStartButton_thenStopAndClear_validateTimer() {
        sut.enterTime(timeInput: "10:00")
        sut.tapStartButton()
        sut.validateTimerIsRunning()
        sut.tapStopButton()
        sut.tapClearButton()
        sut.validateTimerIsStopped()
    }
    
    func test_enterInvalidTime_pressStartButton_errorIsShown() {
        sut.enterTime(timeInput: "70:00")
        sut.tapStartButton()
        sut.validateTimeFormatAlert()
    }
}

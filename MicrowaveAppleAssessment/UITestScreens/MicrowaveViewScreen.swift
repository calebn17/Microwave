//
//  MicrowaveViewScreen.swift
//  MicrowaveAppleAssessment
//
//  Created by Caleb Ngai on 8/11/24.
//

import Foundation
import XCTest

final class MicrowaveViewScreen: XCTest {
    
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    lazy var screenTitleLabel: XCUIElement = app.staticTexts["screen-title"]
    lazy var timer: XCUIElement = app.staticTexts["timer-view"]
    lazy var timeField: XCUIElement = app.textFields["input-time-field"]
    lazy var weightField: XCUIElement = app.textFields["input-weight-field"]
    lazy var powerLevelPicker: XCUIElement = app.pickerWheels["power-level-picker"]
    lazy var startButton: XCUIElement = app.buttons["start-button"]
    lazy var stopButton: XCUIElement = app.buttons["stop-button"]
    lazy var clearButton: XCUIElement = app.buttons["clear-button"]
    lazy var popcornButton: XCUIElement = app.buttons["microwave-popcorn-button"]
    lazy var defrostWeightButton: XCUIElement = app.buttons["defrost-weight-button"]
    lazy var defrostTimeButton: XCUIElement = app.buttons["defrost-time-button"]
    lazy var timeFormatAlert: XCUIElement = app.staticTexts["Entered time is in the wrong format"]
    
    func tapStartButton() {
        XCTAssertTrue(startButton.waitForExistence(timeout: 0.5), "startButton is not found")
        startButton.tap()
    }
    
    func tapStopButton() {
        XCTAssertTrue(stopButton.waitForExistence(timeout: 0.5), "stopButton is not found")
        stopButton.tap()
    }
    
    func tapClearButton() {
        XCTAssertTrue(clearButton.waitForExistence(timeout: 0.5), "clearButton is not found")
        clearButton.tap()
    }
    
    func enterTime(timeInput: String) {
        XCTAssertTrue(timeField.waitForExistence(timeout: 0.5), "timerField is not found")
        timeField.tap()
        timeField.typeText(timeInput)
        
        /// Dismisses keyboard if it shows up
        if app.keyboards.element.exists {
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    func validateTimerIsRunning() {
        XCTAssertTrue(timer.waitForExistence(timeout: 0.5), "timer is not found")
        sleep(3)
        XCTAssertFalse(timer.label == "00:00")
    }
    
    func validateTimerIsStopped() {
        XCTAssertTrue(timer.waitForExistence(timeout: 0.5), "timer is not found")
        sleep(3)
        XCTAssertTrue(timer.label == "00:00")
    }
    
    func validateTimeFormatAlert() {
        XCTAssertTrue(timeFormatAlert.waitForExistence(timeout: 1), "Timer format alert is not found")
        /// Tapping local cancel button
        app.buttons["Cancel"].tap()
    }
    
}

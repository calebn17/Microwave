//
//  MicrowaveAppleAssessmentTests.swift
//  MicrowaveAppleAssessmentTests
//
//  Created by Caleb Ngai on 8/10/24.
//

import XCTest
@testable import MicrowaveAppleAssessment

/// Unit tests
final class MicrowaveViewModelTests: XCTestCase {
    
    private var mockTimer: CustomTimerMock!
    private var sut: MicrowaveViewModel!
    
    @MainActor
    override func setUp() {
        mockTimer = CustomTimerMock()
        sut = MicrowaveViewModel(microwaveTimer: mockTimer)
    }
    
    //MARK: - Example Button Tests
    
    @MainActor
    func test_startButton_wasPressed_startTimerWasCalled() {
        sut.enteredTimeString = "10:00"
        sut.startMicrowave()
        XCTAssertTrue(mockTimer.startTimerCalled)
    }
    
    @MainActor
    func test_stopButton_wasPressed_stopTimerWasCalled() {
        sut.stopMicrowave()
        XCTAssertTrue(mockTimer.stopTimerCalled)
    }
    
    @MainActor
    func test_clearButton_wasPressed_clearTimerWasCalled() {
        sut.clearMicrowaveTimer()
        XCTAssertTrue(mockTimer.clearTimerCalled)
    }

    @MainActor
    func test_defrostByWeightButton_wasPressed_formatTimerWasCalled() {
        sut.enteredWeightString = "50"
        sut.defrost(by: .weight)
        XCTAssertTrue(mockTimer.formatTimerCalled)
    }
    
    //MARK: - Example field validation tests
    
    @MainActor
    func test_timeField_inValidFormat_timeFormatErrorThrown() {
        sut.enteredTimeString = "!@:30"
        sut.startMicrowave()
        XCTAssertEqual(sut.alert, .invalidTime)
    }
    
    @MainActor
    func test_weightField_inValidFormat_weightFormatErrorThrown() {
        sut.enteredWeightString = "50.2"
        sut.defrost(by: .weight)
        XCTAssertEqual(sut.alert, .invalidWeight)
    }
}

//
//  NavigationSmokeUITests.swift
//  AuraUITests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest

final class NavigationSmokeUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITEST_SKIP_WELCOME")
        app.launch()
    }

    func testStatisticsTabOpensStatisticsScreen() {
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.otherElements["StatisticsView"].waitForExistence(timeout: 2))
    }

    func testSettingsTabOpensSettingsScreen() {
        app.tabBars.buttons.element(boundBy: 2).tap()

        XCTAssertTrue(app.otherElements["SettingsView"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["SettingsTitleLabel"].exists)
    }

    func testAddNoteFlowOpensEditNoteScreen() {
        app.otherElements["AddNoteButton"].tap()
        XCTAssertTrue(app.otherElements["AddNoteView"].waitForExistence(timeout: 2))

        let emotionCircle = app.otherElements["YellowEmotionCircle_0"]
        XCTAssertTrue(emotionCircle.waitForExistence(timeout: 2))
        emotionCircle.tap()

        let emotionPickerButton = app.buttons["EmotionPickerButton"]
        XCTAssertTrue(emotionPickerButton.waitForExistence(timeout: 2))
        emotionPickerButton.tap()

        let saveNoteButton = app.buttons["SaveNoteButton"]
        XCTAssertTrue(saveNoteButton.waitForExistence(timeout: 5))
        XCTAssertTrue(saveNoteButton.isHittable)
    }
}

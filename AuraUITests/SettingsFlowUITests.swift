//
//  SettingsFlowUITests.swift
//  AuraUITests
//
//  Created by freegatik on 10.05.2026.
//

import XCTest

final class SettingsFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITEST_SKIP_WELCOME")
        app.launch()
    }

    func testSettingsScreenExposesNotificationAndBiometricSwitches() {
        app.tabBars.buttons.element(boundBy: 2).tap()

        XCTAssertTrue(app.otherElements["SettingsView"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.switches["NotificationsSwitch"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.switches["BiometricSwitch"].exists)
    }
}

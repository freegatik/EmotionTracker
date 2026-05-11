//
//  AuraUITests.swift
//  AuraUITests
//
//  Created by Anton Solovev on 28.04.2025.
//

import XCTest

final class AuraUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        if ProcessInfo.processInfo.environment["CI"] != nil {
            throw XCTSkip("Boilerplate launch test; skipped on CI to save runner time.")
        }
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        if ProcessInfo.processInfo.environment["CI"] != nil {
            throw XCTSkip("XCTApplicationLaunchMetric is slow and flaky on GitHub Actions.")
        }
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

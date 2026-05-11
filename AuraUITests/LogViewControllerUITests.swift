//
//  LogViewControllerUITests.swift
//  AuraUITests
//
//  Created by Anton Solovev on 30.04.2025.
//


import XCTest

final class LogViewControllerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITEST_SKIP_WELCOME")
        app.launch()
    }
    
    func testMainElementsExist() {
        let navBar = app.otherElements["LogNavBar"]
        XCTAssertTrue(navBar.exists, "Навигационная панель должна быть видна на экране")
        
        let titleLabel = app.staticTexts["LogTitleLabel"]
        XCTAssertTrue(titleLabel.exists, "Заголовок должен быть виден на экране")
        
        let activityRing = app.otherElements["ActivityRingView"]
        XCTAssertTrue(activityRing.exists, "Кольцо активности должно быть видно на экране")
        
        let addButton = app.otherElements["AddNoteButton"]
        XCTAssertTrue(addButton.exists, "Кнопка добавления заметки должна быть видна на экране")
        XCTAssertTrue(addButton.isHittable, "Кнопка добавления заметки должна быть доступна для нажатия")
    }
}

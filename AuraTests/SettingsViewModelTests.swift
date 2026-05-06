//
//  SettingsViewModelTests.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest
@testable import Aura

final class SettingsViewModelTests: XCTestCase {
    private var coreDataService: MockCoreDataService!
    private var notificationService: MockNotificationService!
    private var biometricService: MockBiometricService!
    private var viewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()
        coreDataService = MockCoreDataService()
        notificationService = MockNotificationService()
        biometricService = MockBiometricService()
        viewModel = SettingsViewModel(
            notificationService: notificationService,
            coreDataService: coreDataService,
            biometricService: biometricService
        )
        coreDataService.clearAll()
        notificationService.scheduledNotifications.removeAll()
    }

    override func tearDown() {
        coreDataService = nil
        notificationService = nil
        biometricService = nil
        viewModel = nil
        super.tearDown()
    }

    func testAddNotification() {
        let time = "09:00"

        viewModel.addAlertTime(time)

        XCTAssertEqual(viewModel.alertTimes.count, 1)
        XCTAssertEqual(viewModel.alertTimes.first, time)
        XCTAssertEqual(coreDataService.alertTimes.count, 1)
        XCTAssertEqual(coreDataService.alertTimes.first, time)
    }

    func testRemoveNotification() {
        let time = "09:00"
        viewModel.addAlertTime(time)

        viewModel.removeAlertTime(at: 0)

        XCTAssertEqual(viewModel.alertTimes.count, 0)
        XCTAssertEqual(coreDataService.alertTimes.count, 0)
    }

    func testMultipleNotifications() {
        let times = ["09:00", "12:00", "18:00"]

        times.forEach { viewModel.addAlertTime($0) }

        XCTAssertEqual(viewModel.alertTimes.count, 3)
        XCTAssertEqual(viewModel.alertTimes, times)
        XCTAssertEqual(coreDataService.alertTimes.count, 3)
        XCTAssertEqual(coreDataService.alertTimes, times)
    }

    func testNotificationSettingsPersistence() {
        let time = "09:00"
        viewModel.addAlertTime(time)
        viewModel.toggleNotifications(true)

        XCTAssertEqual(coreDataService.alertTimes.count, 1)
        XCTAssertEqual(coreDataService.alertTimes.first, time)

        let newViewModel = SettingsViewModel(
            notificationService: notificationService,
            coreDataService: coreDataService,
            biometricService: biometricService
        )

        XCTAssertEqual(newViewModel.alertTimes.count, 1)
        XCTAssertEqual(newViewModel.alertTimes.first, time)
    }

    func testToggleNotificationsSchedulesExistingAlertsWhenAuthorized() {
        notificationService.isAuthorized = true
        viewModel.addAlertTime("09:00")
        viewModel.addAlertTime("18:30")

        viewModel.toggleNotifications(true)
        waitForMainQueue()

        XCTAssertTrue(viewModel.isNotificationsEnabled)
        XCTAssertTrue(coreDataService.isNotificationsEnabled)
        XCTAssertEqual(notificationService.scheduledNotifications, ["09:00", "18:30"])
        XCTAssertEqual(notificationService.authorizationRequestsCount, 1)
    }

    func testToggleNotificationsShowsPermissionAlertWhenDenied() {
        notificationService.isAuthorized = false

        viewModel.toggleNotifications(true)
        waitForMainQueue()

        XCTAssertFalse(viewModel.isNotificationsEnabled)
        XCTAssertFalse(coreDataService.isNotificationsEnabled)
        XCTAssertTrue(viewModel.showPermissionAlert)
    }

    func testToggleNotificationsOffClearsScheduledNotifications() {
        notificationService.isAuthorized = true
        viewModel.addAlertTime("09:00")
        viewModel.toggleNotifications(true)
        waitForMainQueue()

        viewModel.toggleNotifications(false)

        XCTAssertFalse(viewModel.isNotificationsEnabled)
        XCTAssertFalse(coreDataService.isNotificationsEnabled)
        XCTAssertEqual(notificationService.removeAllNotificationsCalls, 1)
        XCTAssertTrue(notificationService.scheduledNotifications.isEmpty)
    }

    func testToggleBiometricWithUnavailableTypeDoesNotAuthenticate() {
        biometricService = MockBiometricService(biometricType: .none)
        viewModel = SettingsViewModel(
            notificationService: notificationService,
            coreDataService: coreDataService,
            biometricService: biometricService
        )

        viewModel.toggleBiometric(true)

        XCTAssertFalse(viewModel.isBiometricEnabled)
        XCTAssertFalse(coreDataService.isBiometricEnabled)
        XCTAssertEqual(biometricService.authenticateCalls, 0)
    }

    func testToggleBiometricPersistsOnSuccessfulAuthentication() {
        biometricService.biometricType = .faceID
        biometricService.nextResult = (true, nil)

        viewModel.toggleBiometric(true)
        waitForMainQueue()

        XCTAssertTrue(viewModel.isBiometricEnabled)
        XCTAssertTrue(coreDataService.isBiometricEnabled)
        XCTAssertEqual(biometricService.authenticateCalls, 1)
    }

    func testToggleBiometricKeepsDisabledStateOnFailure() {
        biometricService.biometricType = .faceID
        biometricService.nextResult = (false, NSError(domain: "Test", code: 1))

        viewModel.toggleBiometric(true)
        waitForMainQueue()

        XCTAssertFalse(viewModel.isBiometricEnabled)
        XCTAssertFalse(coreDataService.isBiometricEnabled)
        XCTAssertEqual(biometricService.authenticateCalls, 1)
    }

    func testToggleBiometricOffClearsPersistedFlag() {
        biometricService.biometricType = .faceID
        biometricService.nextResult = (true, nil)
        viewModel.toggleBiometric(true)
        waitForMainQueue()

        viewModel.toggleBiometric(false)

        XCTAssertFalse(viewModel.isBiometricEnabled)
        XCTAssertFalse(coreDataService.isBiometricEnabled)
    }
}

private extension SettingsViewModelTests {
    func waitForMainQueue() {
        let expectation = expectation(description: "main queue drained")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

//
//  AppCoordinatorTests.swift
//  AuraTests
//
//  Created by freegatik on 10.05.2026.
//

import XCTest
@testable import Aura

final class AppCoordinatorTests: XCTestCase {
    private func makeDependencies(core: MockCoreDataService) -> AppDependencies {
        AppDependencies.testing(
            coreDataService: core,
            biometricService: MockBiometricService(),
            notificationService: MockNotificationService()
        )
    }

    func testStartWithoutBiometricShowsWelcome() {
        let nav = UINavigationController()
        let core = MockCoreDataService()
        core.isBiometricEnabled = false
        let sut = AppCoordinator(navigationController: nav, dependencies: makeDependencies(core: core))

        sut.start()

        XCTAssertTrue(nav.viewControllers.first is WelcomeViewController)
    }

    func testStartWithBiometricShowsAuthGate() {
        let nav = UINavigationController()
        let core = MockCoreDataService()
        core.isBiometricEnabled = true
        let sut = AppCoordinator(navigationController: nav, dependencies: makeDependencies(core: core))

        sut.start()

        XCTAssertTrue(nav.viewControllers.first is BiometricAuthViewController)
    }

    func testBecomeActiveWithBiometricShowsAuthGateAgain() {
        let nav = UINavigationController()
        let core = MockCoreDataService()
        core.isBiometricEnabled = true
        let sut = AppCoordinator(navigationController: nav, dependencies: makeDependencies(core: core))
        sut.start()
        XCTAssertTrue(nav.viewControllers.first is BiometricAuthViewController)

        nav.setViewControllers([UIViewController()], animated: false)
        sut.handleAppDidBecomeActive()

        XCTAssertTrue(nav.viewControllers.first is BiometricAuthViewController)
    }
}

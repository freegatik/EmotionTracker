//
//  TabBarCoordinatorTests.swift
//  AuraTests
//
//  Created by freegatik on 10.05.2026.
//

import XCTest
@testable import Aura

final class TabBarCoordinatorTests: XCTestCase {
    private func makeDependencies() -> AppDependencies {
        AppDependencies.testing(
            coreDataService: MockCoreDataService(),
            biometricService: MockBiometricService(),
            notificationService: MockNotificationService()
        )
    }

    func testStartEmbedsTabBarWithThreeTabsAndChildCoordinators() {
        let nav = UINavigationController()
        let sut = TabBarCoordinator(navigationController: nav, dependencies: makeDependencies())

        sut.start()

        XCTAssertEqual(nav.viewControllers.count, 1)
        guard let tabBar = nav.viewControllers.first as? TabBarViewController else {
            XCTFail("Expected TabBarViewController root")
            return
        }
        XCTAssertEqual(tabBar.viewControllers?.count, 3)
        XCTAssertEqual(sut.childCoordinators.count, 3)
        XCTAssertTrue(sut.childCoordinators.contains { $0 is LogCoordinator })
        XCTAssertTrue(sut.childCoordinators.contains { $0 is StatisticsCoordinator })
        XCTAssertTrue(sut.childCoordinators.contains { $0 is SettingsCoordinator })
    }
}

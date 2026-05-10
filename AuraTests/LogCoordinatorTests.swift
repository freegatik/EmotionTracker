//
//  LogCoordinatorTests.swift
//  AuraTests
//
//  Created by freegatik on 10.05.2026.
//

import XCTest
import UIKit
@testable import Aura

final class LogCoordinatorTests: XCTestCase {
    private func makeDependencies() -> AppDependencies {
        AppDependencies.testing(
            coreDataService: MockCoreDataService(),
            biometricService: MockBiometricService(),
            notificationService: MockNotificationService()
        )
    }

    private func drainMainQueue() {
        let exp = expectation(description: "main")
        DispatchQueue.main.async { exp.fulfill() }
        waitForExpectations(timeout: 2)
    }

    func testStartSetsLogScreenAsRoot() {
        let nav = UINavigationController()
        let sut = LogCoordinator(navigationController: nav, dependencies: makeDependencies())

        sut.start()

        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers.first is LogViewController)
    }

    func testAddNoteStartsChildCoordinatorAndPushesAddNote() {
        let nav = UINavigationController()
        let sut = LogCoordinator(navigationController: nav, dependencies: makeDependencies())
        sut.start()

        sut.handleAddNoteButtonTapped()
        drainMainQueue()

        XCTAssertEqual(nav.viewControllers.count, 2)
        XCTAssertTrue(nav.viewControllers.last is AddNoteViewController)
        XCTAssertEqual(sut.childCoordinators.count, 1)
        XCTAssertTrue(sut.childCoordinators.first is AddNoteCoordinator)
    }

    func testEmotionCardTapStartsEditNoteCoordinator() {
        let nav = UINavigationController()
        let sut = LogCoordinator(navigationController: nav, dependencies: makeDependencies())
        sut.start()

        let emptySections: [[(tag: String, index: Int)]] = [[], [], []]
        let emotionData = (
            index: 0,
            title: "Радость",
            color: UIColor.yellowPrimary,
            time: "10:00",
            selectedTags: Set<String>(),
            tagsBySection: emptySections,
            selectedSectionTags: Set<EditNoteViewModel.SectionTag>()
        )
        sut.handleEmotionCardTapped(with: emotionData)
        drainMainQueue()

        XCTAssertEqual(nav.viewControllers.count, 2)
        XCTAssertTrue(nav.viewControllers.last is EditNoteViewController)
        XCTAssertEqual(sut.childCoordinators.count, 1)
        XCTAssertTrue(sut.childCoordinators.first is EditNoteCoordinator)
    }
}

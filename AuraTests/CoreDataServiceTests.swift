//
//  CoreDataServiceTests.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest
@testable import Aura

final class CoreDataServiceTests: XCTestCase {
    private var coreDataStack: TestCoreDataStack!
    private var coreDataService: CoreDataService!

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        let testManager = CoreDataManager(persistentContainer: coreDataStack.persistentContainer)
        coreDataService = CoreDataService(coreDataManager: testManager)
    }

    override func tearDown() {
        coreDataService = nil
        coreDataStack = nil
        super.tearDown()
    }

    func testSaveEmotionRecordPersistsRecord() {
        coreDataService.saveEmotionRecord(
            emotion: "Счастье",
            note: "Отличный день",
            tags: ["Работа", "Отдых"],
            color: EmotionColor.yellow.rawValue
        )

        let records = coreDataService.fetchEmotionRecords()

        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.emotion, "Счастье")
        XCTAssertEqual(records.first?.note, "Отличный день")
        XCTAssertEqual(Set(records.first?.tags ?? []), Set(["Работа", "Отдых"]))
        XCTAssertEqual(records.first?.color, EmotionColor.yellow.rawValue)
    }

    func testFetchEmotionRecordsReturnsNewestFirst() {
        coreDataStack.makeEmotionRecord(
            emotion: "Вчера",
            color: EmotionColor.blue.rawValue,
            date: Date(timeIntervalSince1970: 100)
        )
        coreDataStack.makeEmotionRecord(
            emotion: "Сегодня",
            color: EmotionColor.green.rawValue,
            date: Date(timeIntervalSince1970: 200)
        )

        let records = coreDataService.fetchEmotionRecords()

        XCTAssertEqual(records.map(\.emotion), ["Сегодня", "Вчера"])
    }

    func testDeleteEmotionRecordRemovesRecord() {
        let record = coreDataStack.makeEmotionRecord(
            emotion: "Удалить",
            color: EmotionColor.red.rawValue
        )

        coreDataService.deleteEmotionRecord(record)

        XCTAssertTrue(coreDataService.fetchEmotionRecords().isEmpty)
    }

    func testUpdateEmotionRecordPersistsNewValues() {
        let record = coreDataStack.makeEmotionRecord(
            emotion: "Старое",
            note: "Заметка",
            tags: ["Дом"],
            color: EmotionColor.red.rawValue
        )

        coreDataService.updateEmotionRecord(
            record,
            emotion: "Новое",
            note: "Обновлено",
            tags: ["Работа", "Спорт"],
            color: EmotionColor.green.rawValue
        )

        let updatedRecord = coreDataService.fetchEmotionRecords().first
        XCTAssertEqual(updatedRecord?.emotion, "Новое")
        XCTAssertEqual(updatedRecord?.note, "Обновлено")
        XCTAssertEqual(Set(updatedRecord?.tags ?? []), Set(["Работа", "Спорт"]))
        XCTAssertEqual(updatedRecord?.color, EmotionColor.green.rawValue)
    }

    func testUserSettingsPersistAcrossServiceInstances() {
        coreDataService.dailyGoal = 5
        coreDataService.currentStreak = 3
        coreDataService.lastRecordDate = "2025-04-18"
        coreDataService.isNotificationsEnabled = true
        coreDataService.alertTimes = ["09:00", "18:00"]
        coreDataService.isBiometricEnabled = true

        let secondService = CoreDataService(
            coreDataManager: CoreDataManager(persistentContainer: coreDataStack.persistentContainer)
        )

        XCTAssertEqual(secondService.dailyGoal, 5)
        XCTAssertEqual(secondService.currentStreak, 3)
        XCTAssertEqual(secondService.lastRecordDate, "2025-04-18")
        XCTAssertTrue(secondService.isNotificationsEnabled)
        XCTAssertEqual(secondService.alertTimes, ["09:00", "18:00"])
        XCTAssertTrue(secondService.isBiometricEnabled)
    }
}

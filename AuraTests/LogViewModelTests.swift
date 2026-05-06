//
//  LogViewModelTests.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest
@testable import Aura

final class LogViewModelTests: XCTestCase {
    private var coreDataService: MockCoreDataService!
    private var viewModel: LogViewModel!

    override func setUp() {
        super.setUp()
        coreDataService = MockCoreDataService()
        coreDataService.clearAll()
        viewModel = LogViewModel(coreDataService: coreDataService)
    }

    override func tearDown() {
        coreDataService = nil
        viewModel = nil
        super.tearDown()
    }

    func testTodayRecordsCount() {
        viewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .blue,
            selectedTags: ["Работа"]
        )
        viewModel.addNewEmotionCard(
            emotion: "Грусть",
            emotionColor: .red,
            selectedTags: ["Дом"]
        )

        XCTAssertEqual(viewModel.getTodayRecordsCount(), 2)
        XCTAssertTrue(viewModel.hasTodayRecords())
    }

    func testDailyProgress() {
        viewModel.dailyGoal = 3

        viewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .blue,
            selectedTags: ["Работа"]
        )
        viewModel.addNewEmotionCard(
            emotion: "Грусть",
            emotionColor: .red,
            selectedTags: ["Дом"]
        )

        XCTAssertEqual(viewModel.getDailyProgress(), 2.0 / 3.0)
    }

    func testNoRecordsToday() {
        XCTAssertEqual(viewModel.getTodayRecordsCount(), 0)
        XCTAssertFalse(viewModel.hasTodayRecords())
        XCTAssertEqual(viewModel.getDailyProgress(), 0)
    }

    func testDailyProgressExceedsGoal() {
        viewModel.dailyGoal = 2

        viewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .blue,
            selectedTags: ["Работа"]
        )
        viewModel.addNewEmotionCard(
            emotion: "Грусть",
            emotionColor: .red,
            selectedTags: ["Дом"]
        )
        viewModel.addNewEmotionCard(
            emotion: "Радость",
            emotionColor: .green,
            selectedTags: ["Отдых"]
        )

        XCTAssertEqual(viewModel.getDailyProgress(), 1.0)
    }

    func testCreateEmotionRecord() {
        let addNoteViewModel = AddNoteViewModel()

        addNoteViewModel.selectEmotion(emotion: ("Счастье", .yellowPrimary))
        viewModel.addNewEmotionCard(
            emotion: addNoteViewModel.selectedEmotion?.title ?? "",
            emotionColor: .yellow,
            selectedTags: ["Работа", "Успех"]
        )

        XCTAssertEqual(viewModel.getTodayRecordsCount(), 1)
        let records = coreDataService.fetchEmotionRecords()
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.emotion, "Счастье")
        XCTAssertEqual(Set(records.first?.tags ?? []), Set(["Работа", "Успех"]))
    }

    func testCreateEmotionRecordWithCustomTags() {
        let addNoteViewModel = AddNoteViewModel()
        let customTags = ["Новый тег 1", "Новый тег 2"]

        addNoteViewModel.selectEmotion(emotion: ("Грусть", .bluePrimary))
        viewModel.addNewEmotionCard(
            emotion: addNoteViewModel.selectedEmotion?.title ?? "",
            emotionColor: .blue,
            selectedTags: Set(customTags)
        )

        let records = coreDataService.fetchEmotionRecords()
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.emotion, "Грусть")
        XCTAssertEqual(Set(records.first?.tags ?? []), Set(customTags))
    }

    func testLoadEmotionRecordsGroupsCardsByDayKey() {
        let calendar = Calendar.current
        let now = Date()
        coreDataService.seedEmotionRecord(
            emotion: "Счастье",
            tags: ["Работа"],
            color: EmotionColor.yellow.rawValue,
            date: now
        )
        coreDataService.seedEmotionRecord(
            emotion: "Спокойствие",
            tags: ["Дом"],
            color: EmotionColor.green.rawValue,
            date: calendar.date(byAdding: .day, value: -1, to: now)!
        )
        coreDataService.seedEmotionRecord(
            emotion: "Грусть",
            tags: ["Отдых"],
            color: EmotionColor.blue.rawValue,
            date: calendar.date(byAdding: .day, value: -2, to: now)!
        )

        let viewModel = LogViewModel(coreDataService: coreDataService)

        XCTAssertEqual(viewModel.emotionSections.count, 3)
        XCTAssertEqual(viewModel.emotionSections[0].dayKey, LocalizedKey.Log.todayString)
        XCTAssertEqual(viewModel.emotionSections[1].dayKey, LocalizedKey.Log.yesterdayString)
        XCTAssertTrue(viewModel.emotionSections[2].dayKey.contains("назад"))
    }

    func testUpdateEmotionCardUpdatesViewModelAndStoredRecord() {
        viewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .yellow,
            selectedTags: ["Работа"]
        )

        viewModel.updateEmotionCard(
            at: 0,
            title: "Спокойствие",
            color: .green,
            selectedTags: ["Дом", "Отдых"]
        )

        let updatedCard = viewModel.getEmotionData(at: 0)
        let records = coreDataService.fetchEmotionRecords()

        XCTAssertEqual(updatedCard?.emotion, "Спокойствие")
        XCTAssertEqual(updatedCard?.emotionColor, .green)
        XCTAssertEqual(updatedCard?.selectedTags, ["Дом", "Отдых"])
        XCTAssertEqual(records.first?.emotion, "Спокойствие")
        XCTAssertEqual(Set(records.first?.tags ?? []), Set(["Дом", "Отдых"]))
        XCTAssertEqual(records.first?.color, EmotionColor.green.rawValue)
    }

    func testGetCurrentStreakReturnsZeroWhenNoRecentRecordsExist() {
        coreDataService.currentStreak = 4
        coreDataService.lastRecordDate = isoDateString(daysFromNow: -2)

        XCTAssertEqual(viewModel.getCurrentStreak(), 0)
    }

    func testGetCurrentStreakReturnsStoredValueWhenYesterdayExists() {
        coreDataService.currentStreak = 4
        coreDataService.lastRecordDate = isoDateString(daysFromNow: -1)

        XCTAssertEqual(viewModel.getCurrentStreak(), 4)
    }

    func testGetTodayEmotionsForRingUsesDailyGoalAsDenominator() {
        viewModel.dailyGoal = 4
        viewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .yellow,
            selectedTags: ["Работа"]
        )
        viewModel.addNewEmotionCard(
            emotion: "Спокойствие",
            emotionColor: .green,
            selectedTags: ["Дом"]
        )
        viewModel.addNewEmotionCard(
            emotion: "Усталость",
            emotionColor: .green,
            selectedTags: ["Отдых"]
        )

        let segments = viewModel.getTodayEmotionsForRing()
        let percentages = Dictionary(uniqueKeysWithValues: segments.map { ($0.color, $0.percentage) })

        XCTAssertEqual(segments.count, 2)
        XCTAssertEqual(percentages[EmotionColor.yellow.toUIColor()], 0.25)
        XCTAssertEqual(percentages[EmotionColor.green.toUIColor()], 0.5)
    }
}

private extension LogViewModelTests {
    func isoDateString(daysFromNow value: Int) -> String {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: value, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

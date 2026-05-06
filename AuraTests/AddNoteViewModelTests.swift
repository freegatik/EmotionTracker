//
//  AddNoteViewModelTests.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest
@testable import Aura

final class AddNoteViewModelTests: XCTestCase {
    func testEmotionSelection() {
        let viewModel = AddNoteViewModel()
        let expectation = XCTestExpectation(description: "Emotion picker state changed")

        viewModel.onEmotionPickerStateChanged = { state in
            switch state {
            case .active(let emotionTitle, let emotionDescription, let emotionColor):
                XCTAssertEqual(emotionTitle, "Счастье")
                XCTAssertEqual(emotionDescription, "Описание эмоции: Счастье")
                XCTAssertEqual(emotionColor, .yellowPrimary)
            case .inactive:
                XCTFail("State should be active")
            }
            expectation.fulfill()
        }

        viewModel.selectEmotion(emotion: ("Счастье", .yellowPrimary))

        XCTAssertEqual(viewModel.selectedEmotion?.title, "Счастье")
        XCTAssertEqual(viewModel.selectedEmotion?.color, .yellowPrimary)
        wait(for: [expectation], timeout: 1.0)
    }

    func testEmotionList() {
        let viewModel = AddNoteViewModel()

        XCTAssertEqual(viewModel.emotions.count, 16)

        let redEmotions = viewModel.emotions.filter { $0.color == .redPrimary }
        XCTAssertEqual(redEmotions.count, 4)
        XCTAssertTrue(redEmotions.contains { $0.title == "Ярость" })
        XCTAssertTrue(redEmotions.contains { $0.title == "Напряжение" })
        XCTAssertTrue(redEmotions.contains { $0.title == "Зависть" })
        XCTAssertTrue(redEmotions.contains { $0.title == "Беспокойство" })

        let yellowEmotions = viewModel.emotions.filter { $0.color == .yellowPrimary }
        XCTAssertEqual(yellowEmotions.count, 4)
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Возбуждение" })
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Восторг" })
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Уверенность" })
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Счастье" })

        let blueEmotions = viewModel.emotions.filter { $0.color == .bluePrimary }
        XCTAssertEqual(blueEmotions.count, 4)
        XCTAssertTrue(blueEmotions.contains { $0.title == "Выгорание" })
        XCTAssertTrue(blueEmotions.contains { $0.title == "Усталость" })
        XCTAssertTrue(blueEmotions.contains { $0.title == "Депрессия" })
        XCTAssertTrue(blueEmotions.contains { $0.title == "Апатия" })

        let greenEmotions = viewModel.emotions.filter { $0.color == .greenPrimary }
        XCTAssertEqual(greenEmotions.count, 4)
        XCTAssertTrue(greenEmotions.contains { $0.title == "Спокойствие" })
        XCTAssertTrue(greenEmotions.contains { $0.title == "Удовлетворённость" })
        XCTAssertTrue(greenEmotions.contains { $0.title == "Благодарность" })
        XCTAssertTrue(greenEmotions.contains { $0.title == "Защищённость" })
    }

    func testEmotionSelectionMultipleTimes() {
        let viewModel = AddNoteViewModel()
        let expectation = XCTestExpectation(description: "Emotion picker state changed")
        var selectionCount = 0

        viewModel.onEmotionPickerStateChanged = { state in
            switch state {
            case .active(let emotionTitle, _, _):
                if selectionCount == 0 {
                    XCTAssertEqual(emotionTitle, "Счастье")
                } else {
                    XCTAssertEqual(emotionTitle, "Грусть")
                }
                selectionCount += 1
                if selectionCount == 2 {
                    expectation.fulfill()
                }
            case .inactive:
                XCTFail("State should be active")
            }
        }

        viewModel.selectEmotion(emotion: ("Счастье", .yellowPrimary))
        viewModel.selectEmotion(emotion: ("Грусть", .bluePrimary))

        XCTAssertEqual(viewModel.selectedEmotion?.title, "Грусть")
        XCTAssertEqual(viewModel.selectedEmotion?.color, .bluePrimary)
        wait(for: [expectation], timeout: 1.0)
    }
}

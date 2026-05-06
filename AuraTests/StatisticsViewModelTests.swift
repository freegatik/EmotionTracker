//
//  StatisticsViewModelTests.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest
@testable import Aura

final class StatisticsViewModelTests: XCTestCase {
    func testGetEmotionsCountByColorCountsCardsPerColor() {
        let viewModel = StatisticsViewModel()
        viewModel.updateWithTestData([
            makeCard(emotion: "Счастье", color: .yellow),
            makeCard(emotion: "Спокойствие", color: .green),
            makeCard(emotion: "Усталость", color: .green),
            makeCard(emotion: "Грусть", color: .blue),
            makeCard(emotion: "Ярость", color: .red),
        ])

        let counts = viewModel.getEmotionsCountByColor()

        XCTAssertEqual(viewModel.getEmotionsCount(), 5)
        XCTAssertEqual(counts[.yellow], 1)
        XCTAssertEqual(counts[.green], 2)
        XCTAssertEqual(counts[.blue], 1)
        XCTAssertEqual(counts[.red], 1)
    }

    func testGetEmotionColorPercentagesReturnsEmptyForNoCards() {
        let viewModel = StatisticsViewModel()

        XCTAssertTrue(viewModel.getEmotionColorPercentages().isEmpty)
    }

    func testGetEmotionColorPercentagesNormalizesByTotalCount() {
        let viewModel = StatisticsViewModel()
        viewModel.updateWithTestData([
            makeCard(emotion: "Счастье", color: .yellow),
            makeCard(emotion: "Спокойствие", color: .green),
            makeCard(emotion: "Усталость", color: .green),
            makeCard(emotion: "Грусть", color: .blue),
        ])

        let percentages = viewModel.getEmotionColorPercentages()

        XCTAssertEqual(percentages.count, 4)
        XCTAssertEqual(percentage(for: EmotionColor.green.toUIColor(), in: percentages), 0.5)
        XCTAssertEqual(percentage(for: EmotionColor.yellow.toUIColor(), in: percentages), 0.25)
        XCTAssertEqual(percentage(for: EmotionColor.blue.toUIColor(), in: percentages), 0.25)
        XCTAssertEqual(percentage(for: EmotionColor.red.toUIColor(), in: percentages), 0.0)
    }
}

private extension StatisticsViewModelTests {
    func makeCard(emotion: String, color: EmotionColor) -> EmotionCardViewModel {
        EmotionCardViewModel(
            time: "сегодня, 10:00",
            emotion: emotion,
            emotionColor: color,
            icon: nil
        )
    }

    func percentage(
        for color: UIColor,
        in values: [(color: UIColor, percentage: CGFloat)]
    ) -> CGFloat? {
        values.first { $0.color == color }?.percentage
    }
}

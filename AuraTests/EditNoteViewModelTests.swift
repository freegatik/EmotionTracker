//
//  EditNoteViewModelTests.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import XCTest
@testable import Aura

final class EditNoteViewModelTests: XCTestCase {
    func testInitializesDefaultTagsWhenNoCustomSectionsProvided() {
        let viewModel = EditNoteViewModel(
            emotionTitle: "Счастье",
            emotionColor: .yellowPrimary
        )

        XCTAssertEqual(viewModel.getTagsForSection(0), ["Приём пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"])
        XCTAssertEqual(viewModel.getTagsForSection(1), ["Один", "Друзья", "Семья", "Коллеги", "Партнёр", "Питомцы"])
        XCTAssertEqual(viewModel.getTagsForSection(2), ["Дом", "Работа", "Школа", "Транспорт", "Улица"])
    }

    func testAddTagAppendsUniqueTagToSection() {
        let viewModel = EditNoteViewModel(
            emotionTitle: "Счастье",
            emotionColor: .yellowPrimary
        )

        let didAdd = viewModel.addTag("Новый тег", section: 0)

        XCTAssertTrue(didAdd)
        XCTAssertTrue(viewModel.getTagsForSection(0).contains("Новый тег"))
    }

    func testAddTagRejectsDuplicateTagInSection() {
        let viewModel = EditNoteViewModel(
            emotionTitle: "Счастье",
            emotionColor: .yellowPrimary
        )

        let didAdd = viewModel.addTag("Отдых", section: 0)

        XCTAssertFalse(didAdd)
    }

    func testToggleTagAddsAndRemovesSelection() {
        let viewModel = EditNoteViewModel(
            emotionTitle: "Счастье",
            emotionColor: .yellowPrimary
        )

        viewModel.toggleTag("Отдых", section: 0)
        XCTAssertTrue(viewModel.isTagSelected("Отдых", section: 0))
        XCTAssertEqual(viewModel.selectedTags, ["Отдых"])

        viewModel.toggleTag("Отдых", section: 0)
        XCTAssertFalse(viewModel.isTagSelected("Отдых", section: 0))
        XCTAssertTrue(viewModel.selectedTags.isEmpty)
    }

    func testSelectedTagsSetterMapsTagsAcrossSections() {
        let viewModel = EditNoteViewModel(
            emotionTitle: "Счастье",
            emotionColor: .yellowPrimary
        )

        viewModel.selectedTags = ["Дом", "Друзья", "Отдых"]

        XCTAssertTrue(viewModel.isTagSelected("Дом", section: 2))
        XCTAssertTrue(viewModel.isTagSelected("Друзья", section: 1))
        XCTAssertTrue(viewModel.isTagSelected("Отдых", section: 0))
        XCTAssertEqual(viewModel.selectedTags, ["Дом", "Друзья", "Отдых"])
    }
}

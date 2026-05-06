//
//  MockCoreDataService.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import CoreData
import Foundation
@testable import Aura

final class MockCoreDataService: CoreDataServiceProtocol {
    let coreDataStack: TestCoreDataStack

    var alertTimes: [String] = []
    var isNotificationsEnabled: Bool = false
    var dailyGoal: Int = 3
    var lastRecordDate: String?
    var currentStreak: Int = 0
    var isBiometricEnabled: Bool = false

    init(coreDataStack: TestCoreDataStack = TestCoreDataStack()) {
        self.coreDataStack = coreDataStack
    }

    func saveEmotionRecord(emotion: String, note: String?, tags: [String]?, color: String?) {
        coreDataStack.makeEmotionRecord(
            emotion: emotion,
            note: note,
            tags: tags,
            color: color
        )
    }

    func fetchEmotionRecords() -> [EmotionRecord] {
        let request = EmotionRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try coreDataStack.context.fetch(request)
        } catch {
            return []
        }
    }

    func deleteEmotionRecord(_ record: EmotionRecord) {
        coreDataStack.context.delete(record)
        coreDataStack.save()
    }

    func updateEmotionRecord(_ record: EmotionRecord, emotion: String, note: String?, tags: [String]?, color: String?) {
        record.emotion = emotion
        record.note = note
        record.tags = tags
        record.color = color
        coreDataStack.save()
    }

    func clearAll() {
        alertTimes.removeAll()
        isNotificationsEnabled = false
        dailyGoal = 3
        lastRecordDate = nil
        currentStreak = 0
        isBiometricEnabled = false
        coreDataStack.deleteAllRecords()
    }

    @discardableResult
    func seedEmotionRecord(
        emotion: String,
        note: String? = nil,
        tags: [String]? = nil,
        color: String? = nil,
        date: Date
    ) -> EmotionRecord {
        coreDataStack.makeEmotionRecord(
            emotion: emotion,
            note: note,
            tags: tags,
            color: color,
            date: date
        )
    }
}

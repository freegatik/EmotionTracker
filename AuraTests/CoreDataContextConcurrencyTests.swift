//
//  CoreDataContextConcurrencyTests.swift
//  AuraTests
//
//  Created by freegatik on 10.05.2026.
//

import CoreData
import XCTest
@testable import Aura

final class CoreDataContextConcurrencyTests: XCTestCase {
    /// Child `NSManagedObjectContext` (private queue) rolls up into the view context — documents the supported multi-context pattern.
    func testChildContextSaveMergesIntoViewContextAndPersists() {
        let stack = TestCoreDataStack()
        let child = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        child.parent = stack.context
        child.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        let childDone = expectation(description: "child save")
        child.perform {
            let record = EmotionRecord(context: child)
            record.date = Date()
            record.emotion = "Nested"
            record.color = EmotionColor.red.rawValue
            do {
                try child.save()
            } catch {
                XCTFail("Child save failed: \(error)")
            }
            childDone.fulfill()
        }
        waitForExpectations(timeout: 5)

        stack.context.performAndWait {
            do {
                try stack.context.save()
            } catch {
                XCTFail("View context save failed: \(error)")
            }
            let request = EmotionRecord.fetchRequest()
            do {
                let count = try stack.context.count(for: request)
                XCTAssertEqual(count, 1)
                let rows = try stack.context.fetch(request)
                XCTAssertEqual(rows.first?.emotion, "Nested")
            } catch {
                XCTFail("Count/fetch failed: \(error)")
            }
        }
    }
}

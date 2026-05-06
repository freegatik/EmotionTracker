//
//  TestCoreDataStack.swift
//  AuraTests
//
//  Created by Anton Solovev on 06.05.2026.
//

import CoreData
@testable import Aura

final class TestCoreDataStack {
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        let model = Self.loadManagedObjectModel()

        persistentContainer = NSPersistentContainer(name: "Aura", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                preconditionFailure("Unable to load in-memory Core Data store: \(error)")
            }
        }

        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static func loadManagedObjectModel() -> NSManagedObjectModel {
        let bundles = [Bundle.main, Bundle(for: CoreDataManager.self), Bundle(for: TestCoreDataStack.self)] + Bundle.allBundles + Bundle.allFrameworks

        for bundle in bundles {
            if let modelURL = bundle.url(forResource: "Aura", withExtension: "momd") ??
                bundle.url(forResource: "Aura", withExtension: "mom"),
               let model = NSManagedObjectModel(contentsOf: modelURL) {
                return model
            }
        }

        preconditionFailure("Unable to load Aura Core Data model")
    }

    @discardableResult
    func makeEmotionRecord(
        emotion: String,
        note: String? = nil,
        tags: [String]? = nil,
        color: String? = nil,
        date: Date = Date()
    ) -> EmotionRecord {
        let record = EmotionRecord(context: context)
        record.date = date
        record.emotion = emotion
        record.note = note
        record.tags = tags
        record.color = color
        save()
        return record
    }

    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            preconditionFailure("Unable to save test context: \(error)")
        }
    }

    func deleteAllRecords() {
        let emotionRecordsRequest = EmotionRecord.fetchRequest()
        let emotionRecords = (try? context.fetch(emotionRecordsRequest)) ?? []
        emotionRecords.forEach(context.delete)

        let settingsRequest = UserSettings.fetchRequest()
        let settings = (try? context.fetch(settingsRequest)) ?? []
        settings.forEach(context.delete)

        save()
        context.reset()
    }
}

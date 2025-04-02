//
//  CoreDataManager.swift
//  Aura
//
//  Created by Anton Solovev on 02.04.2025.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Aura")
        container.loadPersistentStores { _, error in
            if let error = error {
                AppLog.persistence.fault("Unable to load persistent stores: \(error.localizedDescription, privacy: .public)")
                fatalError("Core Data store failed to load: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            AppLog.persistence.error("Save failed: \(error.localizedDescription, privacy: .public)")
            context.rollback()
        }
    }
}

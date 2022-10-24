//
//  Persistence.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()

    private let container = NSPersistentContainer(name: CoreData.containerName)
    private let databaseName = CoreData.databaseName

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private var oldStoreURL: URL {
        guard let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return URL(fileURLWithPath: "")
        }
        return directory.appendingPathComponent(databaseName)
    }

    private var sharedStoreURL: URL {
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: CoreData.groupIdentifier) else {
            return URL(fileURLWithPath: "")
        }

        return container.appendingPathComponent(databaseName)
    }

    private init() {
        saveStoreURL(!FileManager.default.fileExists(atPath: oldStoreURL.path))
        loadStores()
        migrateStore()
        context.automaticallyMergesChangesFromParent = true
    }

    private func saveStoreURL(_ isNeededToSaveNewURL: Bool) {
        guard isNeededToSaveNewURL else { return }
        guard let description = container.persistentStoreDescriptions.first else { return }
        description.url = sharedStoreURL
    }

    private func loadStores() {
        container.loadPersistentStores { desc, error in
              if let error = error {
                  print(error.localizedDescription)
              }
        }
    }

    private func migrateStore() {
        print("Went into MigrateStore")
        let coordinator = container.persistentStoreCoordinator

        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else { return }
        print("old store no longer exists")

        do {
            let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            print("Migration Succeed")
        } catch {
            fatalError("Unable to migrate to shared store")
        }

        do {
            try FileManager.default.removeItem(at: oldStoreURL)
            print("Old Store Deleted")
        } catch {
            print("Unable to delete oldStore")
        }
    }
}

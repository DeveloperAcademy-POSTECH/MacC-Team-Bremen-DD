//
//  Persistence.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    let container = NSPersistentContainer(name: "DataModel")
    let cloudContainer = NSPersistentCloudKitContainer(name: "DataModel")
    let databaseName = "DataModel.sqlite"

    var context: NSManagedObjectContext {
        container.viewContext
    }

    var oldStoreURL: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(databaseName)
    }

    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Bremen-DD.Rlog")!
        return container.appendingPathComponent(databaseName)
    }

    init() {
        print("core data init")

        if !FileManager.default.fileExists(atPath: oldStoreURL.path) {
            print("old store doesn't exist. Using new shared URL")
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }

        print("Container URL = \(container.persistentStoreDescriptions.first!.url!)")

        container.loadPersistentStores { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func migrateStore(for container: NSPersistentContainer) {
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

// MARK: - CRUD LOGIC
extension CoreDataManager {
    func save() {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }

    // MARK: - WORKSPACE CRUD
    func createWorkspace(name: String, paymentDay: Int16, hourlyWage: Int16, color: String, hasTax: Bool, hasJuhyu: Bool) {
        let workspace = WorkspaceEntity(context: context)
        workspace.name = name
        workspace.paymentDay = paymentDay
        workspace.hourlyWage = hourlyWage
        workspace.color = color
        workspace.hasTax = hasTax
        workspace.hasJuhyu = hasJuhyu
        save()
    }

    func getAllWorkspaces() -> [WorkspaceEntity] {
        let fetchRequest: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    // MARK: - SCHEDULE CRUD
    func createSchedule(of workspace: WorkspaceEntity, repeatedSchedule: [String], startTime: String, endTime: String, spentHour: Int16) {
        let schedule = ScheduleEntity(context: context)
        schedule.workspace = workspace
        schedule.repeatedSchedule = repeatedSchedule
        schedule.startTime = startTime
        schedule.endTime = endTime
        schedule.spentHour = spentHour
        save()
    }

    func getAllSchedules(of workspace: WorkspaceEntity) -> [ScheduleEntity] {
        let fetchRequest: NSFetchRequest<ScheduleEntity> = ScheduleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workspace.name = %@", workspace.name )
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func editSchedule(pf schedule: ScheduleEntity, repeatedSchedule: [String], startTime: String, endTime: String, spentHour: Int16) {
        schedule.repeatedSchedule = repeatedSchedule
        schedule.startTime = startTime
        schedule.endTime = endTime
        schedule.spentHour = spentHour
        save()
    }

    func deleteSchedule(of schedule: ScheduleEntity) {
        context.delete(schedule)
        save()
    }

    // MARK: - WORKDAY CRUD
    func createWorkday(of workspace: WorkspaceEntity, weekDay: Int16, yearInt: Int16, monthInt: Int16, dayInt: Int16, startTime: String, endTime: String, spentHour: Int16) {
        let workday = WorkDayEntity(context: context)
        workday.workspace = workspace
        workday.id = UUID()
        workday.weekDay = weekDay
        workday.yearInt = yearInt
        workday.monthInt = monthInt
        workday.dayInt = dayInt
        workday.startTime = startTime
        workday.endTime = endTime
        workday.spentHour = spentHour
        save()
    }

    func getAllWorkdays(of workspace: WorkspaceEntity) -> [WorkDayEntity] {
        let fetchRequest: NSFetchRequest<WorkDayEntity> = WorkDayEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workspace.name = %@", workspace.name )
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func editWorkday(of workday: WorkDayEntity, weekDay: Int16, yearInt: Int16, monthInt: Int16, dayInt: Int16, startTime: String, endTime: String, spentHour: Int16) {
        workday.weekDay = weekDay
        workday.yearInt = yearInt
        workday.monthInt = monthInt
        workday.dayInt = dayInt
        workday.startTime = startTime
        workday.endTime = endTime
        workday.spentHour = spentHour
        save()
    }

    func deleteWorkDay(of workday: WorkDayEntity) {
        context.delete(workday)
        save()
    }
}

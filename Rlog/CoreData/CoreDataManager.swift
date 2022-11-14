//
//  Persistence.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()

    private let container = NSPersistentContainer(name: "DataModel")

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        loadStores()
    }

    private func loadStores() {
        container.loadPersistentStores { desc, error in
              if let error = error {
                  print(error.localizedDescription)
              }
        }
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }
}

// MARK: - Workspace Logic
extension CoreDataManager {
    func createWorkspace(
        name: String,
        payDay: Int16,
        hourlyWage: Int32,
        hasTax: Bool,
        hasJuhyu: Bool
    ) {
        let workspace = WorkspaceEntity(context: context)
        workspace.name = name
        workspace.payDay = payDay
        workspace.hourlyWage = hourlyWage
        workspace.hasTax = hasTax
        workspace.hasJuhyu = hasJuhyu
        save()
    }

    func getAllWorkspaces() -> [WorkspaceEntity] {
        let fetchRequest: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func editWorkspace(
        workspace: WorkspaceEntity,
        name: String,
        payDay: Int16,
        hourlyWage: Int32,
        hasTax: Bool,
        hasJuhyu: Bool
    ) {
        workspace.name = name
        workspace.payDay = payDay
        workspace.hourlyWage = hourlyWage
        workspace.hasTax = hasTax
        workspace.hasJuhyu = hasJuhyu
        save()
    }

    func deleteWorkspace(workspace: WorkspaceEntity) {
        context.delete(workspace)
        save()
    }
}

// MARK: - ScheduleEntity Logic
extension CoreDataManager {
    func createSchedule(
        of workspace: WorkspaceEntity,
        repeatDays: [String],
        startHour: Int16,
        startMinute: Int16,
        endHour: Int16,
        endMinute: Int16
    ) {
        let schedule = ScheduleEntity(context: context)
        schedule.workspace = workspace
        schedule.repeatDays = repeatDays
        schedule.startHour = startHour
        schedule.startMinute = startMinute
        schedule.endHour = endHour
        schedule.endMinute = endMinute
        save()
    }

    func getSchedules(of workspace: WorkspaceEntity) -> [ScheduleEntity] {
        let fetchRequest: NSFetchRequest<ScheduleEntity> = ScheduleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workspace.name = %@", workspace.name)
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func editSchedule(
        of schedule: ScheduleEntity,
        repeatDays: [String],
        startHour: Int16,
        startMinute: Int16,
        endHour: Int16,
        endMinute: Int16
    ) {
        schedule.repeatDays = repeatDays
        schedule.startHour = startHour
        schedule.startMinute = startMinute
        schedule.endHour = endHour
        schedule.endMinute = endMinute
        save()
    }

    func deleteSchedule(of schedule: ScheduleEntity) {
         context.delete(schedule)
         save()
     }
}

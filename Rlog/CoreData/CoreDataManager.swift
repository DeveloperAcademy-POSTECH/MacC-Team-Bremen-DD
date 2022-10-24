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
}

extension CoreDataManager {
    private func save() {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }

    // MARK: - WORKSPACE CRUD
    func createWorkspace(name: String, paymentDay: Int16, hourlyWage: Int16, colorString: String, hasTax: Bool, hasJuhyu: Bool) {
        let workspace = WorkspaceEntity(context: context)
        workspace.name = name
        workspace.paymentDay = paymentDay
        workspace.hourlyWage = hourlyWage
        workspace.colorString = colorString
        workspace.hasTax = hasTax
        workspace.hasJuhyu = hasJuhyu
        save()
    }

    func getAllWorkspaces() -> [WorkspaceEntity] {
        let fetchRequest: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func deleteWorkspace(workspace: WorkspaceEntity) {
        context.delete(workspace)
        save()
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

    func editSchedule(of schedule: ScheduleEntity, repeatedSchedule: [String], startTime: String, endTime: String, spentHour: Int16) {
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

}

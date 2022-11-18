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

// MARK: - WorkspaceEntity Logic
extension CoreDataManager {
    func createWorkspace(
        name: String,
        payDay: Int16,
        hourlyWage: Int32,
        hasTax: Bool,
        hasJuhyu: Bool
    ) -> WorkspaceEntity {
        let workspace = WorkspaceEntity(context: context)
        workspace.name = name
        workspace.payDay = payDay
        workspace.hourlyWage = hourlyWage
        workspace.hasTax = hasTax
        workspace.hasJuhyu = hasJuhyu
        save()
        return workspace
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
    ) -> ScheduleEntity {
        let schedule = ScheduleEntity(context: context)
        schedule.workspace = workspace
        schedule.repeatDays = repeatDays
        schedule.startHour = startHour
        schedule.startMinute = startMinute
        schedule.endHour = endHour
        schedule.endMinute = endMinute
        save()
        return schedule
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

// MARK: - WorkdayEntity Logic
extension CoreDataManager {
    func createWorkday(
        of workspace: WorkspaceEntity,
        hourlyWage: Int32,
        hasDone: Bool,
        date: Date,
        startTime: Date,
        endTime: Date,
        memo: String?,
        schedule: ScheduleEntity?
    ) {
        let workday = WorkdayEntity(context: context)
        workday.workspace = workspace
        workday.hourlyWage = hourlyWage
        workday.hasDone = hasDone
        workday.date = date
        workday.startTime = startTime
        workday.endTime = endTime
        workday.memo = memo
        workday.schedule = schedule
        save()
    }

    func getWorkdaysBetween(start: Date, target: Date) -> [WorkdayEntity] {
        let fetchRequest: NSFetchRequest<WorkdayEntity> = WorkdayEntity.fetchRequest()
        let startPredicate = NSPredicate(format: "date >= %@", start as CVarArg)
        let targetPredicate = NSPredicate(format: "date < %@", target as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [startPredicate, targetPredicate])
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func getHasNotDoneWorkdays() -> [WorkdayEntity] {
        let fetchRequest: NSFetchRequest<WorkdayEntity> = WorkdayEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "hasDone == %@", NSNumber(booleanLiteral: false))
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func getHasDoneWorkdays(of workspace: WorkspaceEntity, start: Date, target: Date) -> [WorkdayEntity] {
        let fetchRequest: NSFetchRequest<WorkdayEntity> = WorkdayEntity.fetchRequest()
        let workspacePredicate = NSPredicate(format: "workspace.name = %@", workspace.name)
        let startPredicate = NSPredicate(format: "date >= %@", start as CVarArg)
        let targetPredicate = NSPredicate(format: "date < %@", target as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [workspacePredicate, startPredicate, targetPredicate])
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func deleteWorkday(of workday: WorkdayEntity) {
         context.delete(workday)
         save()
     }
}

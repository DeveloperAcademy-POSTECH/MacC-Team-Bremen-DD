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
    func createWorkspace(name: String, hourlyWage: Int16, paymentDay: Int16, colorString: String, hasTax: Bool, hasJuhyu: Bool) {
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

    func getWorkspace(by name: String) -> WorkspaceEntity? {
        let fetchRequest: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        let result = try? context.fetch(fetchRequest).first
        return result
    }

    func editWorkspace(workspace: WorkspaceEntity, name: String, hourlyWage: Int16, paymentDay: Int16, colorString: String, hasTax: Bool, hasJuhyu: Bool) {
        workspace.name = name
        workspace.paymentDay = paymentDay
        workspace.hourlyWage = hourlyWage
        workspace.colorString = colorString
        workspace.hasTax = hasTax
        workspace.hasJuhyu = hasJuhyu
        save()
    }

    func deleteWorkspace(workspace: WorkspaceEntity) {
        context.delete(workspace)
        save()
    }

    // MARK: - SCHEDULE CRUD
    func createSchedule(of workspace: WorkspaceEntity, repeatedSchedule: [String], startHour: Int16, startMinute: Int16,  endHour: Int16, endMinute: Int16, spentHour: Double) {
        let schedule = ScheduleEntity(context: context)
        schedule.workspace = workspace
        schedule.repeatedSchedule = repeatedSchedule
        schedule.startHour = startHour 
        schedule.startMinute = startMinute
        schedule.endHour = endHour
        schedule.endMinute = endMinute
        schedule.spentHour = spentHour
        save()
    }

    func getAllSchedules(of workspace: WorkspaceEntity) -> [ScheduleEntity] {
        let fetchRequest: NSFetchRequest<ScheduleEntity> = ScheduleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workspace.name = %@", workspace.name )
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
    func getAllSchedules() -> [ScheduleEntity] {
        let fetchRequest: NSFetchRequest<ScheduleEntity> = ScheduleEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func editSchedule(of schedule: ScheduleEntity, repeatedSchedule: [String], startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16, spentHour: Double) {
        schedule.repeatedSchedule = repeatedSchedule
        schedule.startHour = startHour
        schedule.startMinute = startMinute
        schedule.endHour = endHour
        schedule.endMinute = endMinute
        schedule.spentHour = spentHour
        save()
    }

    func deleteSchedule(of schedule: ScheduleEntity) {
        context.delete(schedule)
        save()
    }

    // MARK: - WORKDAY CRUD

    func createWorkday(of workspace: WorkspaceEntity, weekDay: Int16, yearInt: Int16, monthInt: Int16, dayInt: Int16, startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16, spentHour: Double, workDayType: Int16) {
        let workday = WorkDayEntity(context: context)
        workday.workspace = workspace
        workday.id = UUID()
        workday.workDayType = workDayType
        workday.weekDay = weekDay
        workday.yearInt = yearInt
        workday.monthInt = monthInt
        workday.dayInt = dayInt
        workday.startHour = startHour
        workday.startMinute = startMinute
        workday.endHour = endHour
        workday.endMinute = endMinute
        workday.spentHour = spentHour
        workday.hasDone = false
        save()
    }

    func getAllWorkdays(of workspace: WorkspaceEntity) -> [WorkDayEntity] {
        let fetchRequest: NSFetchRequest<WorkDayEntity> = WorkDayEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workspace.name = %@", workspace.name )
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func getWorkdays(of workspace: WorkspaceEntity, yearInt: Int, monthInt: Int, limit: Int) -> [WorkDayEntity] {
        let fetchRequest: NSFetchRequest<WorkDayEntity> = WorkDayEntity.fetchRequest()
        let workspacePredicate = NSPredicate(format: "workspace.name = %@", workspace.name )
        let yearPredicate = NSPredicate(format: "yearInt == %i", yearInt)
        let monthPredicate = NSPredicate(format: "monthInt == %i", monthInt)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [workspacePredicate, yearPredicate, monthPredicate])
        fetchRequest.fetchLimit = limit
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }


    func getWorkdaysByMonth(yearInt: Int, monthInt: Int) -> [WorkDayEntity] {
        let fetchRequest: NSFetchRequest<WorkDayEntity> = WorkDayEntity.fetchRequest()
        let yearPredicate = NSPredicate(format: "yearInt == %i", yearInt)
        let monthPredicate = NSPredicate(format: "monthInt == %i", monthInt)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [yearPredicate, monthPredicate])
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }


    func editWorkday(of workday: WorkDayEntity, weekDay: Int16, yearInt: Int16, monthInt: Int16, dayInt: Int16, startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16, spentHour: Double, hasDone: Bool, workDayType: Int16) {
        workday.weekDay = weekDay
        workday.workDayType = workDayType
        workday.yearInt = yearInt
        workday.monthInt = monthInt
        workday.dayInt = dayInt
        workday.startHour = startHour
        workday.startMinute = startMinute
        workday.endHour = endHour
        workday.endMinute = endMinute
        workday.spentHour = spentHour
        workday.hasDone = hasDone
        save()
    }

    func deleteWorkDay(of workday: WorkDayEntity) {
        context.delete(workday)
        save()
    }
}

//
//  WorkSpaceDetailViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

@MainActor
final class WorkspaceDetailViewModel: ObservableObject {
    var workspace: WorkspaceEntity
    
    @Published var name: String
    @Published var hourlyWageString: String
    @Published var paymentDayString: String
    @Published var hasTax: Bool
    @Published var hasJuhyu: Bool
    @Published var isAlertOpen = false
    @Published var isCreateScheduleModalShow = false
    
    // TODO: - 리팩토링이 필요한 부분으로 생각됨
    // https://fdsa0106.atlassian.net/browse/BD-197?atlOrigin=eyJpIjoiZTBjMjczNGMzZmI1NDJmNmFmNmVlOTQ0NjhkOTI2ZGYiLCJwIjoiaiJ9
    var deleteSchedules: [ScheduleEntity] = []
    @Published var schedules: [ScheduleEntity] = []
    @Published var shouldCreateSchedules: [ScheduleModel] = []
    
    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        self.name = workspace.name
        self.hourlyWageString = String(workspace.hourlyWage)
        self.paymentDayString = String(workspace.payDay)
        self.hasTax = workspace.hasTax
        self.hasJuhyu = workspace.hasJuhyu
        getAllSchedules()
    }
    
    func didTapConfirmButton(completion: @escaping (() -> Void)) {
        if checkScheduleConflict(creatSchedules: shouldCreateSchedules, existSchedules: schedules.filter {  })
        Task {
            await updateWorkspace()
            await deleteSchedules()
            let schedules = await createSchedules()
            for schedule in schedules {
                await createInitWorkdays(worspace: workspace, schedule: schedule)
            }
            completion()
        }
    }
    
    func didTapDeleteButton(completion: @escaping (() -> Void)) {
        Task {
            await deleteWorkspace()
            completion()
        }
    }
    
    func didTapDeleteScheduleButton(schedule: ScheduleEntity) {
        if let index = schedules.firstIndex(of: schedule) {
            deleteSchedules.append(schedules[index])
            schedules.remove(at: index)
        }
    }
    
    func didTapDeleteScheduleModelButton(schedule: ScheduleModel) {
        if let index = shouldCreateSchedules.firstIndex(of: schedule) {
            shouldCreateSchedules.remove(at: index)
        }
    }
}

private extension WorkspaceDetailViewModel {
    func updateWorkspace() async {
        CoreDataManager.shared.editWorkspace(
            workspace: workspace,
            name: name,
            payDay: Int16(paymentDayString) ?? 1,
            hourlyWage: Int32(hourlyWageString) ?? 10000,
            hasTax: hasTax,
            hasJuhyu: hasJuhyu
        )
    }
    
    func deleteWorkspace() async {
        CoreDataManager.shared.deleteWorkspace(workspace: workspace)
    }
    
    func deleteSchedules() async {
        for schedule in deleteSchedules {
            CoreDataManager.shared.deleteSchedule(of: schedule)
        }
    }
    
    func createSchedules() async -> [ScheduleEntity] {
        var createdSchedules: [ScheduleEntity] = []
        for schedule in shouldCreateSchedules {
            createdSchedules.append(
                CoreDataManager.shared.createSchedule(
                    of: workspace,
                    repeatDays: schedule.repeatedSchedule,
                    startHour: schedule.startHour,
                    startMinute: schedule.startMinute,
                    endHour: schedule.endHour,
                    endMinute: schedule.endMinute
                )
            )
        }
        return createdSchedules
    }
    
    func createInitWorkdays(worspace: WorkspaceEntity, schedule: ScheduleEntity) async {
        var range = Date()
        guard let after5Month = Calendar.current.date(byAdding: DateComponents(month: 5), to: range) else { return }
        
        while range < after5Month {
            if schedule.repeatDays.contains(range.fetchDayOfWeek(date: range)) {
                guard let startTime = Calendar.current.date(bySettingHour: Int(schedule.startHour), minute: Int(schedule.startMinute), second: 0, of: range),
                      let endTime = Calendar.current.date(bySettingHour: Int(schedule.endHour), minute: Int(schedule.endMinute), second: 0, of: range),
                      let date = range.onlyDate else { return }
                
                CoreDataManager.shared.createWorkday(
                    of: workspace,
                    hourlyWage: workspace.hourlyWage,
                    hasDone: false,
                    date: date,
                    startTime: startTime,
                    endTime: endTime,
                    memo: nil,
                    schedule: schedule
                )
            }
            
            guard let next = Calendar.current.date(byAdding: DateComponents(day: 1), to: range) else { return }
            range = next
        }
    }
    
    func getAllSchedules() {
        let result = CoreDataManager.shared.getSchedules(of: workspace)
        schedules = result
    }
    
    func checkScheduleConflict(creatSchedules: [ScheduleModel], existSchedules: [ScheduleEntity]) -> Bool {
        for creatSchedule in creatSchedules {
            for existSchedule in existSchedules {
                for day in existSchedule.repeatDays {
                    if creatSchedule.repeatedSchedule. contains(day) {
                        return true
                    }
                }
            }
        }
        return false
    }
}

//
//  WorkSpaceDetailViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

@MainActor
final class WorkSpaceDetailViewModel: ObservableObject {
    var workspace: WorkspaceEntity
    var deleteSchedules: [ScheduleEntity] = []
    
    @Published var name: String
    @Published var hourlyWageString: String
    @Published var paymentDayString: String
    @Published var hasTax: Bool
    @Published var hasJuhyu: Bool
    @Published var isAlertOpen = false
    @Published var isCreateScheduleModalShow = false
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
        Task {
            await updateWorkspace()
            await deleteSchedules()
            await createSchedules()
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

private extension WorkSpaceDetailViewModel {
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
    
    func createSchedules() async {
        for schedule in shouldCreateSchedules {
            CoreDataManager.shared.createSchedule(
                of: workspace,
                repeatDays: schedule.repeatedSchedule,
                startHour: Int16(schedule.startHour) ?? 12,
                startMinute: Int16(schedule.startMinute) ?? 0,
                endHour: Int16(schedule.endHour) ?? 14,
                endMinute: Int16(schedule.endMinute) ?? 0
            )
        }
    }
    
    func getAllSchedules() {
        let result = CoreDataManager.shared.getSchedules(of: workspace)
        schedules = result
    }
}

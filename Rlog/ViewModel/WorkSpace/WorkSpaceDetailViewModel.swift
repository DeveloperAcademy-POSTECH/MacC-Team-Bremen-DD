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
    
    @Published var name: String
    @Published var hourlyWageString: String
    @Published var paymentDayString: String
    @Published var hasTax: Bool
    @Published var hasJuhyu: Bool
    @Published var isAlertOpen = false
    @Published var isCreateScheduleModalShow = false
    @Published var schedules: [ScheduleModel] = []
    
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
            await updateSchedules()
            completion()
        }
    }
    
    func didTapDeleteButton(completion: @escaping (() -> Void)) {
        Task {
            await deleteWorkspace()
            completion()
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
    
    func updateSchedules() async {
        for schedule in schedules {
            if let scheduleEntity = schedule.scheduleEntity {
                CoreDataManager.shared.editSchedule(
                    of: scheduleEntity,
                    repeatDays: schedule.repeatedSchedule,
                    startHour: Int16(schedule.startHour) ?? 12,
                    startMinute: Int16(schedule.startMinute) ?? 0,
                    endHour: Int16(schedule.endHour) ?? 15,
                    endMinute: Int16(schedule.endMinute) ?? 0
                )
            } else {
                CoreDataManager.shared.createSchedule(
                    of: workspace,
                    repeatDays: schedule.repeatedSchedule,
                    startHour: Int16(schedule.startHour) ?? 12,
                    startMinute: Int16(schedule.startMinute) ?? 0,
                    endHour: Int16(schedule.endHour) ?? 15,
                    endMinute: Int16(schedule.endMinute) ?? 0
                )
            }
        }
    }
    
    func getAllSchedules() {
        let result = CoreDataManager.shared.getSchedules(of: workspace)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for schedule in result {
                self.schedules.append(ScheduleModel(
                    scheduleEntity: schedule,
                    repeatedSchedule: schedule.repeatDays,
                    startHour: String(schedule.startHour),
                    startMinute: String(schedule.startMinute),
                    endHour: String(schedule.endHour),
                    endMinute: String(schedule.endMinute)
                ))
            }
        }
    }
}

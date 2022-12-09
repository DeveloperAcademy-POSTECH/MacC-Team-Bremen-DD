//
//  WorkSpaceCreateConfirmationViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/25.
//

import SwiftUI

@MainActor
final class WorkspaceCreateConfirmationViewModel: ObservableObject {
    @Binding var isActiveNavigation: Bool
    
    var workspaceData: WorkSpaceModel
    var scheduleData: [ScheduleModel]
    
    init(isActiveNavigation: Binding<Bool>, workspaceData: WorkSpaceModel, scheduleData: [ScheduleModel]) {
        self._isActiveNavigation = isActiveNavigation
        self.workspaceData = workspaceData
        self.scheduleData = scheduleData
    }
    
    private let hasTax = false
    private let hasJuhyu = false
    
    func didTapConfirmButton() {
        Task {
            await createWorkspaceAndSchedule()
            popToRoot()
        }
    }
}

private extension WorkspaceCreateConfirmationViewModel {
    func popToRoot() {
        self.isActiveNavigation = false
    }
    
    func calculateSpentHour(startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16) -> Double {
        let formatter = DateFormatter(dateFormatType: .timeAndMinute)
        
        let startDate = formatter.date(from: "\(startHour):\(startMinute)")
        let endDate = formatter.date(from: "\(endHour):\(endMinute)")
        
        guard let startDate = startDate,
              let endDate = endDate else { return 0.0 }
        
        let timeInterval = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        
        return (timeInterval / 3600)
    }
    
    func createWorkspaceAndSchedule() async {
        Task {
            let workspace = await createWorkSpace()
            let schedules = await createSchedules(workspace: workspace)
            for schedule in schedules {
                await createInitWorkdays(workspace: workspace, schedule: schedule)
            }
        }
    }
    
    func createWorkSpace() async -> WorkspaceEntity {
        return CoreDataManager.shared.createWorkspace(
            name: workspaceData.name,
            payDay: Int16(workspaceData.paymentDay) ?? 0,
            hourlyWage: Int32(workspaceData.hourlyWage) ?? 0,
            hasTax: workspaceData.hasTax,
            hasJuhyu: workspaceData.hasJuhyu
        )
    }
    
    func createSchedules(workspace: WorkspaceEntity) async -> [ScheduleEntity] {
        var schedules: [ScheduleEntity] = []
        for schedule in scheduleData  {
            schedules.append(
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
        return schedules
    }
    
    func createInitWorkdays(workspace: WorkspaceEntity, schedule: ScheduleEntity) async {
        var range = Date()
        guard let after5Month = Calendar.current.date(byAdding: DateComponents(month: 5), to: range) else { return }
        
        while range < after5Month {
            if schedule.repeatDays.contains(range.weekDay) {
                guard let startTime = Calendar.current.date(bySettingHour: Int(schedule.startHour), minute: Int(schedule.startMinute), second: 0, of: range),
                      var endTime = Calendar.current.date(bySettingHour: Int(schedule.endHour), minute: Int(schedule.endMinute), second: 0, of: range),
                      let date = range.onlyDate else { return }
                
                if startTime >= endTime {
                    endTime = Calendar.current.date(byAdding: DateComponents(day: 1), to: endTime) ?? endTime
                }
                
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
}


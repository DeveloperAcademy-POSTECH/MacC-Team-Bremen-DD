//
//  MainTabViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

@MainActor
final class MainTabViewModel: ObservableObject {
    func updateAllSchedules() async {
        let workspaces = CoreDataManager.shared.getAllWorkspaces()
        
        var schedules: [ScheduleEntity] = []
        for workspace in workspaces {
            schedules.append(contentsOf: CoreDataManager.shared.getSchedules(of: workspace))
        }
        
        for schedule in schedules {
            await updateWorkdays(workspace: schedule.workspace, schedule: schedule)
        }
    }
    
    func updateWorkdays(workspace: WorkspaceEntity, schedule: ScheduleEntity) async {
        guard let after4month = Calendar.current.date(byAdding: DateComponents(month: 4), to: Date()) else { return }
        
        // TODO: - 마지막 날짜 가져오기
        let lastDateOfWorkdays = Date()
        
        if lastDateOfWorkdays < after4month {
            guard var range = Calendar.current.date(byAdding: DateComponents(day: 1), to: lastDateOfWorkdays) else { return }
            guard let lastAfter1Month = Calendar.current.date(byAdding: DateComponents(month: 1), to: lastDateOfWorkdays) else { return }
            while range < lastAfter1Month {
                if schedule.repeatDays.contains(range.fetchDayOfWeek(date: range)) {
                    guard let startTime = Calendar.current.date(bySettingHour: Int(schedule.startHour), minute: Int(schedule.startMinute), second: 0, of: range) else { return }
                    guard let endTime = Calendar.current.date(bySettingHour: Int(schedule.endHour), minute: Int(schedule.endMinute), second: 0, of: range) else { return }
                    
                    CoreDataManager.shared.createWorkday(
                        of: workspace,
                        hourlyWage: workspace.hourlyWage,
                        hasDone: false,
                        date: range,
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
}

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
        
        for workspace in workspaces {
            let workdays = CoreDataManager.shared.getAllWorkdays(of: workspace)
            let schedules = CoreDataManager.shared.getSchedules(of: workspace)
            
            for schedule in schedules {
                let workdaysOfSchedule = workdays.filter { $0.schedule == schedule }
                
                // MARK: - Testing
                guard let testDate = Calendar.current.date(byAdding: DateComponents(month: 1), to: Date()) else { return }
                
//                guard let after4monthOfCurrent = Calendar.current.date(byAdding: DateComponents(month: 4), to: Date()) else { return }
                guard let after4monthOfCurrent = Calendar.current.date(byAdding: DateComponents(month: 4), to: testDate) else { return }
                guard var latestWorkday = workdaysOfSchedule.last else { return }
                print("DEBUG: - TestDate : \(after4monthOfCurrent)")
                print("DEBUG: - LatestDate : \(latestWorkday.date)")
                
                if latestWorkday.date < after4monthOfCurrent {
                    guard var range = Calendar.current.date(byAdding: DateComponents(day: 1), to: latestWorkday.date) else { return }
                    guard let after1MonthOfLatestDate = Calendar.current.date(byAdding: DateComponents(month: 1), to: latestWorkday.date) else { return }
                    
                    while range < after1MonthOfLatestDate {
                        if schedule.repeatDays.contains(range.fetchDayOfWeek(date: range)) {
                            print(range)
                            
//                            guard let startTime = Calendar.current.date(bySettingHour: Int(schedule.startHour), minute: Int(schedule.startMinute), second: 0, of: range) else { return }
//                            guard let endTime = Calendar.current.date(bySettingHour: Int(schedule.endHour), minute: Int(schedule.endMinute), second: 0, of: range) else { return }
//
//                            CoreDataManager.shared.createWorkday(
//                                of: workspace,
//                                hourlyWage: workspace.hourlyWage,
//                                hasDone: false,
//                                date: range,
//                                startTime: startTime,
//                                endTime: endTime,
//                                memo: nil,
//                                schedule: schedule
//                            )
                        }
                        
                        guard let next = Calendar.current.date(byAdding: DateComponents(day: 1), to: range) else { return }
                        range = next
                    }
                }
            }
        }
    }
}

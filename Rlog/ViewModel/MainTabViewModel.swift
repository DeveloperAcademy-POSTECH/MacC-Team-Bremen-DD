//
//  MainTabViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

@MainActor
final class MainTabViewModel: ObservableObject {
    func onAppear() {
        Task {
            await updateAllSchedules()
        }
    }
}

private extension MainTabViewModel {
    func updateAllSchedules() async {
        let workspaces = CoreDataManager.shared.getAllWorkspaces()
        
        for workspace in workspaces {
            // workspace에 연결된 모든 schedule과 workday들을 가져옵니다.
            let workdays = CoreDataManager.shared.getAllWorkdays(of: workspace)
            let schedules = CoreDataManager.shared.getSchedules(of: workspace)
            
            for schedule in schedules {
                // 모든 schedule에 대해 해당 스케줄에 연결된 Workday를 가져옵니다. - CoreDataManager에 schedule에 연결된 Workday들을 가져오는 함수가 있으면 더 편할 것 같습니다.
                let workdaysOfSchedule = workdays.filter { $0.schedule == schedule }
                
                // 현재로부터 4개월 후와, 마지막 날의 Workday를 가져옵니다.
                guard let after4monthOfCurrent = Calendar.current.date(byAdding: DateComponents(month: 4), to: Date()),
                      let latestWorkday = workdaysOfSchedule.last else { return }
                
                // 4개월 후의 날짜가 마지막 날의 날짜보다 클 경우에, 추가로 1달치를 생성합니다.
                if latestWorkday.date < after4monthOfCurrent {
                    guard var range = Calendar.current.date(byAdding: DateComponents(day: 1), to: latestWorkday.date),
                          let after1MonthOfLatestDate = Calendar.current.date(byAdding: DateComponents(month: 1), to: latestWorkday.date) else { return }
                    
                    while range < after1MonthOfLatestDate {
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
            }
        }
    }
}

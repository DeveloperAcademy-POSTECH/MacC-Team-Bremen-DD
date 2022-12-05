//
//  SchedulePendingListViewModel.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/14.
//

import Foundation

final class ScheduleHasNotDoneListViewModel: ObservableObject {
    let timeManager = TimeManager()
    @Published var sortedHasNotDoneWorkdays: [(Date, [WorkdayEntity])] = []
    @Published var hasNotDoneWorkdays: [WorkdayEntity] = [] {
        didSet {
            self.sortedHasNotDoneWorkdays = sortHasNotdoneWorkdaysByDate()
        }
    }
    
    func onAppear() {
        getSortedHasNotDoneWorkdays()
        print("🔥", sortedHasNotDoneWorkdays)
    }
}

private extension ScheduleHasNotDoneListViewModel {
    // 현재 날짜를 기준으로 과거의 근무 일정 중,
    // 확정하지 않은 일정만 필터링합니다.
    func getSortedHasNotDoneWorkdays() {
        hasNotDoneWorkdays.removeAll()
        
        let result = CoreDataManager.shared.getHasNotDoneWorkdays()
        let hasNotdoneWorkdaysBeforeToday = result.filter {
            let date = $0.date
            let endTime = $0.endTime
            let today = Date()
            let compareResult = timeManager.compareDate(date1: endTime, date2: today, unit: .minute)
            
            return date <= today && compareResult
        }
        
        let filteredArray = hasNotdoneWorkdaysBeforeToday.uniqued()
        
        hasNotDoneWorkdays = filteredArray.sorted { $0.date < $1.date }
    }
    
    // 미확정 일정을 날짜 별로 분류합니다.
    func sortHasNotdoneWorkdaysByDate() -> [(Date, [WorkdayEntity])] {
        let dateArray = hasNotDoneWorkdays.map { $0.date.onlyDate ?? Date() }
        var sortedArray: [(Date, [WorkdayEntity])] = []
        var workdayArray: [WorkdayEntity] = []

        for date in dateArray.uniqued() {
            for workday in hasNotDoneWorkdays {
                if workday.date.onlyDate == date.onlyDate {
                    workdayArray.append(workday)
                }
            }
            
            sortedArray.append((date, workdayArray))
            workdayArray.removeAll()
        }
        return sortedArray
    }
}

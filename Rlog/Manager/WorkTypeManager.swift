//
//  WorkTypeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/24.
//

import SwiftUI

final class WorkTypeManager {
    private let timeManager = TimeManager()
    
    func defineWorkType(workday: WorkdayEntity) -> WorkDayType {
        let calendar = Calendar.current
        let workspace = workday.workspace
        let schedules = CoreDataManager.shared.getSchedules(of: workspace)
        let weekday = timeManager.getWeekdayOfDate(workday.date)
        let workdayStartTime = workday.startTime
        let workdayEndTime = workday.endTime
        let workdayStartHour = calendar.component(.hour, from: workdayStartTime)
        let workdayStartMinute = calendar.component(.minute, from: workdayStartTime)
        let workdaySpentHour = timeManager.calculateTimeGapBetweenTwoDate(start: workdayStartTime, end: workdayEndTime)

        for schedule in schedules {
            let repeatDays = schedule.repeatDays
            let startHour = schedule.startHour
            let startMinute = schedule.startMinute
            let endHour = schedule.endHour
            let endMinute = schedule.endMinute

            // 스케쥴에 없는 요일이라면 -> 추가 근무
            guard repeatDays.contains(weekday),
                  startHour == workdayStartHour, startMinute == workdayStartMinute,
                  let spentHour = timeManager.calculateTimeGap(
                    startHour: startHour,
                    startMinute: startMinute,
                    endHour: endHour,
                    endMinute: endMinute
                  )
            else { return .extraDay }

            // 만약 시작 시간이 같다면 아래 경우를 검사한다
            // if : 시작 시간이 같고 일한 시간이 같다면 -> 정규 근무
            // else if : 시작 시간이 같지만 일한 시간이 더 적다면 -> 축소 근무
            // else : 시작 시간이 같지만 일한 시간이 같거나 적지 않다면 -> 연장 근무
            if workdaySpentHour == spentHour {
                return .regular
            } else if workdaySpentHour < spentHour {
                return .reduce
            } else {
                return .overtime
            }
        }
        return .extraDay
    }
}

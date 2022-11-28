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
        if workday.schedule == nil { return .extraDay }

        let workspace = workday.workspace
        let schedules = CoreDataManager.shared.getSchedules(of: workspace)

        let weekday = timeManager.getWeekdayOfDate(workday.date)
        let workdayStartTime = workday.startTime
        let workdayEndTime = workday.endTime
        let workdaySpentHour = timeManager.calculateTimeGapBetweenTwoDate(start: workdayStartTime, end: workdayEndTime)

        for schedule in schedules {
            let repeatDays = schedule.repeatDays
            let startHour = schedule.startHour
            let startMinute = schedule.startMinute
            let endHour = schedule.endHour
            let endMinute = schedule.endMinute

            guard repeatDays.contains(weekday),
                  let spentHour = timeManager.calculateTimeGap(
                      startHour: startHour,
                      startMinute: startMinute,
                      endHour: endHour,
                      endMinute: endMinute
                    )
            else { continue }

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

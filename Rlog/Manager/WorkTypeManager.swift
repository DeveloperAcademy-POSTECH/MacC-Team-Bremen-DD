//
//  WorkTypeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/24.
//

import SwiftUI

final class WorkTypeManager {
    func defineWorkType(workday: WorkdayEntity) -> WorkDayType {
        guard let relatedSchedule = workday.schedule else { return .extraDay }

        let workspace = workday.workspace
        let schedules = CoreDataManager.shared.getSchedules(of: workspace)

        let workdayStartTime = workday.startTime
        let workdayEndTime = workday.endTime
        let workdaySpentHour = Date.calculateTimeGapBetweenTwoDate(start: workdayStartTime, end: workdayEndTime)

        for schedule in schedules {
            let startHour = schedule.startHour
            let startMinute = schedule.startMinute
            let endHour = schedule.endHour
            let endMinute = schedule.endMinute

            guard schedule.objectID == relatedSchedule.objectID,
                  let spentHour = Date.calculateTimeGap(
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

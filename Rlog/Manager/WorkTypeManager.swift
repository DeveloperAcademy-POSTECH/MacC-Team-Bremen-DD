//
//  WorkTypeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/24.
//

import SwiftUI

final class WorkTypeManager {
    private let timeManager = TimeManager()
    
    func defineWorkType(data: WorkdayEntity) -> WorkDayType {
        guard
            let repeatDays = data.schedule?.repeatDays,
            let startHour = data.schedule?.startHour,
            let startMinute = data.schedule?.startMinute,
            let endHour = data.schedule?.endHour,
            let endMinute = data.schedule?.endMinute
        else { return .extraDay }
        
        let weekday = timeManager.getWeekdayOfDate(data.date)
        let normalSpentHour = data.endTime - data.startTime
        guard let spentHour = timeManager.calculateTimeGap(
            startHour: startHour,
            startMinute: startMinute,
            endHour: endHour,
            endMinute: endMinute
        ) else { return .regular }

        if repeatDays.contains(weekday), normalSpentHour == spentHour {
            return .regular
        }

        switch spentHour  {
        case 1...:
            return .overtime
        case _ where spentHour < 0:
            return .reduce
        default:
            return .regular
        }
    }
}

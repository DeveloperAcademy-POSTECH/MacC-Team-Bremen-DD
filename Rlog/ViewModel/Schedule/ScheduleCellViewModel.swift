//
//  ScheduleCellViewModel.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/22.
//

import SwiftUI

extension Date {
}

final class ScheduleCellViewModel {
    let timeManager = TimeManager()
    
    func defineWorkType(
        repeatDays: [String],
        data: WorkdayEntity
    ) -> (type: String, color: Color) {
        guard
            let repeatDays = data.schedule?.repeatDays,
            let startHour = data.schedule?.startHour,
            let startMinute = data.schedule?.startMinute,
            let endHour = data.schedule?.endHour,
            let endMinute = data.schedule?.endMinute
        else { return ("추가", Color.pointPurple) }
        let weekday = timeManager.getWeekdayOfDate(data.date)
        let normalSpentHour = data.endTime - data.startTime
        let spentHour = timeManager.calculateTimeGap(
            startHour: startHour,
            startMinute: startMinute,
            endHour: endHour,
            endMinute: endMinute
        )

        if
            repeatDays.contains(weekday),
            normalSpentHour == spentHour {
            return ("정규", Color.primary)
        }

        switch spentHour  {
        case 0:
            return ("정규", Color.primary)
        case 1...:
            return ("연장", Color.pointBlue)
        case _ where spentHour < 0:
            return ("축소", Color.pointRed)
        default:
            return ("정규", .green)
        }
    }
    
    func verifyIsScheduleExpired(endTime: Date) -> Bool {
        let order = NSCalendar.current.compare(Date(), to: endTime, toGranularity: .minute)
        switch order {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    
    func didTapConfirmationButton(_ data: WorkdayEntity) {
        toggleWorkdayHasDoneEntity(data)
    }
    
    func getSpentHour(_ endTime: Date, _ startTime: Date) -> (Int, Int) {
        let timeGap = endTime - startTime
        let result = timeManager.secondsToHoursMinutesSeconds(timeGap)
        
        return (result.0, result.1)
    }
}

private extension ScheduleCellViewModel {
    func toggleWorkdayHasDoneEntity(_ data: WorkdayEntity) {
        CoreDataManager.shared.toggleHasDone(of: data)
    }
}

//
//  ScheduleUpdateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Foundation
import SwiftUI

enum TimeUnit: String, CaseIterable {
    case minusOneHour = "-1시간"
    case minusHalfHour = "-30분"
    case plusHalfHour = "+30분"
    case plusOneHour = "+1시간"
}

final class ScheduleUpdateViewModel: ObservableObject {
    @Published var workDay: WorkDayEntity
    @Published var reason = ""
    
    init(workDay: WorkDayEntity) {
        self.workDay = workDay
    }
    
    func confirmButtonTapped() {
        // TODO: - spendTime update
        CoreDataManager.shared.editWorkday(
            of: workDay,
            weekDay: workDay.weekDay,
            yearInt: workDay.yearInt,
            monthInt: workDay.monthInt,
            dayInt: workDay.dayInt,
            startTime: workDay.startTime,
            endTime: workDay.endTime,
            spentHour: workDay.spentHour,
            hasDone: workDay.hasDone
        )
    }
}

final class TimeEditerViewModel: ObservableObject {
    @Binding var time: String
    
    init(time: Binding<String>) {
        self._time = time
    }
    
    func timePresetButtonTapped(unit: TimeUnit) {
        var setTime = DateFormatter().fetchTimeStringToDate(time: time)
        switch unit {
        case .minusOneHour:
            setTime.addTimeInterval(-60 * 60)
        case .minusHalfHour:
            setTime.addTimeInterval(-30 * 60)
        case .plusHalfHour:
            setTime.addTimeInterval(30 * 60)
        case .plusOneHour:
            setTime.addTimeInterval(60 * 60)
        }
        time = DateFormatter().fetchTimeDateToString(time: setTime)
    }
}


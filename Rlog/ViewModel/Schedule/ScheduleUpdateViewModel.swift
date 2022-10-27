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
    @Published var startTime: String
    @Published var endTime: String
    @Published var isStartTimeChanaged = false
    @Published var isEndTimeChanaged = false
    @Published var reason = ""
    let weekDay: Int16
    let yearInt: Int16
    let monthInt: Int16
    let dayInt: Int16
    let hasDone: Bool
    // TODO: - spendHour를 double로 수정
    var spendHour: Int16 { return calculateSpentHour(startTime: startTime, endTime: endTime) }
    
    init(workDay: WorkDayEntity) {
        self.workDay = workDay
        weekDay = workDay.weekDay
        yearInt = workDay.yearInt
        monthInt = workDay.monthInt
        dayInt = workDay.dayInt
        hasDone = workDay.hasDone
        startTime = workDay.startTime
        endTime = workDay.endTime
    }
    
    func didTapConfirmButton() async {
        try? await updateWorkday()
    }
    
    func didTapDeleteButton() async {
        try? await deleteWorkday()
    }
}

private extension ScheduleUpdateViewModel {
    func updateWorkday() async throws {
        CoreDataManager.shared.editWorkday(
            of: workDay,
            weekDay: weekDay,
            yearInt: yearInt,
            monthInt: monthInt,
            dayInt: dayInt,
            startTime: startTime,
            endTime: endTime,
            spentHour: spendHour,
            hasDone: hasDone
        )
    }
    
    func deleteWorkday() async throws {
        CoreDataManager.shared.deleteWorkDay(of: workDay)
    }
    
    // TODO: - Int16 -> Double로 수정, startTime, endTime 수정
    func calculateSpentHour(startTime: String, endTime: String) -> Int16 {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startDate = formatter.date(from: startTime)
        let endDate = formatter.date(from: endTime)
        
        guard let startDate = startDate, let endDate = endDate else { return 0 }
        let timeInterval = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        
        return Int16(timeInterval / 3600)
    }
}

final class TimeEditerViewModel: ObservableObject {
    @Binding var time: String
    @Binding var isTimeChanged: Bool
    var fontColor: Color {
        return isTimeChanged ? .white : .fontBlack
    }
    var backgroundColor: Color {
        return isTimeChanged ? Color.primary : Color(UIColor.systemGray5)
    }
    
    init(time: Binding<String>, isTimeChanged: Binding<Bool>) {
        self._time = time
        self._isTimeChanged = isTimeChanged
    }
    
    func didTapTimePresetButton(unit: TimeUnit) {
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
        isTimeChanged = true
    }
}


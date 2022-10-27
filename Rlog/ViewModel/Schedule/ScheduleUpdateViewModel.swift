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
    // TODO: - spendHour를 double로 수정
    @Published var reason = ""
    let weekDay: Int16
    let yearInt: Int16
    let monthInt: Int16
    let dayInt: Int16
    let hasDone: Bool
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


//
//  ScheduleUpdateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum TimeUnit: String, CaseIterable {
    case minusOneHour = "-1시간"
    case minusHalfHour = "-30분"
    case plusHalfHour = "+30분"
    case plusOneHour = "+1시간"
}

final class ScheduleUpdateViewModel: ObservableObject {
    @Published var workDayEntity: WorkDayEntity
    @Published var isStartTimeChanaged = false
    @Published var isEndTimeChanaged = false
    @Published var reason = ""
    var workDay: WorkDay
    // TODO: - spendHour를 double로 수정
    
    init(workDayEntity: WorkDayEntity) {
        self.workDayEntity = workDayEntity
        self.workDay = WorkDay(
            weekDay: workDayEntity.weekDay,
            yearInt: workDayEntity.yearInt,
            monthInt: workDayEntity.monthInt,
            dayInt: workDayEntity.dayInt,
            startTime: workDayEntity.startTime,
            endTime: workDayEntity.endTime,
            hasDone: workDayEntity.hasDone,
            spentHour: workDayEntity.spentHour
        )
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
        workDay.spentHour = calculateSpentHour(startTime: workDay.startTime, endTime: workDay.endTime)
        CoreDataManager.shared.editWorkday(
            of: workDayEntity,
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
    
    func deleteWorkday() async throws {
        CoreDataManager.shared.deleteWorkDay(of: workDayEntity)
    }
    
    // TODO: - Int16 -> Double로 수정, startTime, endTime 수정, 시간 관련 struct로 이동
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

final class TimeEditorViewModel: ObservableObject {
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
        let formatter = DateFormatter(dateFormatType: .timeAndMinute)
        guard var setTime = formatter.date(from: time) else { return }
        
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
        time = formatter.string(from: setTime)
        isTimeChanged = true
    }
}


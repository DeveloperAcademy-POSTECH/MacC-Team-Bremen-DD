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

// TODO: - 임시로 만든 모델 옮기기(파일 새로 생성 후 적용)
struct Workday {
    var weekDay: Int16
    var yearInt: Int16
    var monthInt: Int16
    var dayInt: Int16
    var startTime: String
    var endTime: String
    var hasDone: Bool
    var spendHour: Int16
}

final class ScheduleUpdateViewModel: ObservableObject {
    @Published var workDayEntity: WorkDayEntity
    @Published var isStartTimeChanaged = false
    @Published var isEndTimeChanaged = false
    @Published var reason = ""
    var workday: Workday
    // TODO: - spendHour를 double로 수정
    
    init(workDay: WorkDayEntity) {
        workDayEntity = workDay
        self.workday = Workday(
            weekDay: workDay.weekDay,
            yearInt: workDay.yearInt,
            monthInt: workDay.monthInt,
            dayInt: workDay.dayInt,
            startTime: workDay.startTime,
            endTime: workDay.endTime,
            hasDone: workDay.hasDone,
            spendHour: workDay.spentHour
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
        workday.spendHour = calculateSpentHour(startTime: workday.startTime, endTime: workday.endTime)
        CoreDataManager.shared.editWorkday(
            of: workDayEntity,
            weekDay: workday.weekDay,
            yearInt: workday.yearInt,
            monthInt: workday.monthInt,
            dayInt: workday.dayInt,
            startTime: workday.startTime,
            endTime: workday.endTime,
            spentHour: workday.spendHour,
            hasDone: workday.hasDone,
            workDayType: 0
        )
    }
    
    func deleteWorkday() async throws {
        CoreDataManager.shared.deleteWorkDay(of: workDayEntity)
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
        var formatter = DateFormatter(dateFormatType: .timeAndMinute)
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


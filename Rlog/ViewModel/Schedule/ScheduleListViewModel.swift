//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum ScheduleCase: String, CaseIterable {
    case upcoming = "예정된 일정"
    case past = "지나간 일정"
}

final class ScheduleListViewModel: ObservableObject {
    @Published var selectedScheduleCase: ScheduleCase = .upcoming
    @Published var allWorkDays: [WorkDayEntity] = []
    @Published var isShowCreateModal = false
    var upcomingWorkDays: [WorkDayEntity] = []
    var pastWorkDays: [WorkDayEntity] = []
    let yearAndMonth: String = Date().fetchYearAndMonth()
    
    init() {
        initWorkDays()
        fetchAllWorkDays()
    }
    
    func didSheetDismissed() {
        fetchAllWorkDays()
    }
    
    func didTapPlusButton() {
        isShowCreateModal.toggle()
    }
}

private extension ScheduleListViewModel {
    func fetchAllWorkDays() {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.allWorkDays = CoreDataManager.shared.getWorkdaysByMonth(yearInt: year, monthInt: month)
            self.upcomingWorkDays = self.allWorkDays.filter { self.isUpcomingOrNotDone(hasDone: $0.hasDone, day: $0.dayInt) }
            self.pastWorkDays = self.allWorkDays.filter { !self.isUpcomingOrNotDone(hasDone: $0.hasDone, day: $0.dayInt) }
        }
    }
    
    func initWorkDays() {
        let allSchedules = CoreDataManager.shared.getAllSchedules()
        var date = Date()
        guard let dateAfterMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: date) else { return }
        // TODO: - CoreDataManager에 한 달 이후의 WorkDays를 가져오는 함수가 들어올 경우에 한 줄로 수정 예정
        var workDays = CoreDataManager.shared.getWorkdaysByMonth(yearInt: Calendar.current.component(.year, from: date), monthInt: Calendar.current.component(.month, from: date))
        let nextMonthWorkDays = CoreDataManager.shared.getWorkdaysByMonth(yearInt: Calendar.current.component(.year, from: dateAfterMonth), monthInt: Calendar.current.component(.month, from: dateAfterMonth))
        workDays.append(contentsOf: nextMonthWorkDays)
        
        while date < dateAfterMonth {
            for schedule in allSchedules {
                for weekDay in schedule.repeatedSchedule {
                    if weekDay == date.fetchDayOfWeek(date: date) {
                        var isAlreadyMade = false
                        for workDay in workDays {
                            if workDay.monthInt == Calendar.current.component(.month, from: date) && workDay.dayInt == Calendar.current.component(.day, from: date) {
                                isAlreadyMade = true
                            }
                        }
                        
                        if !isAlreadyMade {
                            CoreDataManager.shared.createWorkday(
                                of: schedule.workspace,
                                weekDay: fetchWeekDayInt(weekDay: date.fetchDayOfWeek(date: date)),
                                yearInt: Int16(Calendar.current.component(.year, from: date)),
                                monthInt: Int16(Calendar.current.component(.month, from: date)),
                                dayInt: Int16(Calendar.current.component(.day, from: date)),
                                startHour: schedule.startHour,
                                startMinute: schedule.startMinute,
                                endHour: schedule.endHour,
                                endMinute: schedule.endMinute,
                                spentHour: schedule.spentHour,
                                workDayType: 0
                            )
                        }
                    }
                }
            }
            
            guard let addDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: date) else { return }
            date = addDate
        }
    }
    
    // TODO: - 날짜 struct 만들기
    func isUpcomming(day: Int16) -> Bool {
        return day > Calendar.current.component(.day, from: Date())
    }
    
    func isUpcomingOrNotDone(hasDone: Bool, day: Int16) -> Bool {
        return !hasDone || isUpcomming(day: day)
    }
    
    func fetchWeekDayInt(weekDay: String) -> Int16 {
        switch weekDay {
        case "월":
            return 0
        case "화":
            return 1
        case "수":
            return 2
        case "목":
            return 3
        case "금":
            return 4
        case "토":
            return 5
        case "일":
            return 6
        default:
            return 0
        }
    }
}

final class StatusPickerViewModel: ObservableObject {
    @Binding var selectedScheduleCase: ScheduleCase
    let scheduleCases = ScheduleCase.allCases
    var statusPickerOffset: CGFloat {
        selectedScheduleCase == .upcoming ? -40 : 40
    }
    
    init(selectedScheduleCase: Binding<ScheduleCase>) {
        self._selectedScheduleCase = selectedScheduleCase
    }
    
    func getStatusPickerTextWeight(compareCase: ScheduleCase) -> Font.Weight {
        return selectedScheduleCase == compareCase ? Font.Weight.bold : Font.Weight.regular
    }
    
    func getStatusPickerForegroundColor(compareCase: ScheduleCase) -> Color {
        return selectedScheduleCase == compareCase ? .white : Color.grayLight
    }
}

final class ScheduleCellViewModel: ObservableObject {
    @Published var isShowUpdateModal = false
    @Published var workDay: WorkDay
    var workDayEntity: WorkDayEntity
    var didDismiss: () -> Void
    var isShowConfirmButton: Bool {
        if !isUpcomming(day: workDay.dayInt) {
            return !workDay.hasDone
        }
        return false
    }
    
    init(workDayEntity: WorkDayEntity, didDismiss: @escaping () -> Void) {
        self.workDayEntity = workDayEntity
        self.workDay = WorkDay(
            weekDay: workDayEntity.weekDay,
            yearInt: workDayEntity.yearInt,
            monthInt: workDayEntity.monthInt,
            dayInt: workDayEntity.dayInt,
            startHour: workDayEntity.startHour,
            startMinute: workDayEntity.startMinute,
            endHour: workDayEntity.endHour,
            endMinute: workDayEntity.endMinute,
            hasDone: workDayEntity.hasDone,
            spentHour: workDayEntity.spentHour,
            workDayType: workDayEntity.workDayType
        )
        self.didDismiss = didDismiss
    }
    
    func didTapConfirmButton() {
        Task {
            try? await updateHasDone()
            didDismiss()
        }
    }
    
    func didTapEditButton() {
        isShowUpdateModal.toggle()
    }
}

private extension ScheduleCellViewModel {
    func updateHasDone() async throws {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workDay.hasDone = true
            CoreDataManager.shared.editWorkday(
                of: self.workDayEntity,
                weekDay: self.workDay.weekDay,
                yearInt: self.workDay.yearInt,
                monthInt: self.workDay.monthInt,
                dayInt: self.workDay.dayInt,
                startHour: self.workDay.startHour,
                startMinute: self.workDay.startMinute,
                endHour: self.workDay.endHour,
                endMinute: self.workDay.endMinute,
                spentHour: self.workDay.spentHour,
                hasDone: self.workDay.hasDone,
                workDayType: self.workDay.workDayType
            )
        }
    }
    
    // TODO: - 날짜 struct 만들기
    func isUpcomming(day: Int16) -> Bool {
        return day > Calendar.current.component(.day, from: Date())
    }
}

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
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for workspace in result {
                self.allWorkDays.append(contentsOf: CoreDataManager.shared.getWorkdays(
                    of: workspace,
                    yearInt: Calendar.current.component(.year, from: Date()),
                    monthInt: Calendar.current.component(.month, from: Date()),
                    limit: 20)
                )
            }
            self.upcomingWorkDays = self.allWorkDays.filter { self.isUpcomming(day: $0.dayInt) }
            self.pastWorkDays = self.allWorkDays.filter { !self.isUpcomming(day: $0.dayInt) }
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
        if day >= Calendar.current.component(.day, from: Date()) {
            return true
        }
        return false
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
        return selectedScheduleCase == compareCase ? .white : Color.fontLightGray
    }
}

final class ScheduleCellViewModel: ObservableObject {
    @Published var isShowUpdateModal = false
    var workDay: WorkDay
    var workDayEntity: WorkDayEntity
    var didDismiss: () -> Void
    var isShowConfirmButton: Bool {
        if isToday(month: workDay.monthInt, day: workDay.dayInt) {
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
        }
    }
    
    func didTapEditButton() {
        isShowUpdateModal.toggle()
    }
}

private extension ScheduleCellViewModel {
    func updateHasDone() async throws {
        workDay.hasDone = true
        CoreDataManager.shared.editWorkday(
            of: workDayEntity,
            weekDay: workDay.weekDay,
            yearInt: workDay.yearInt,
            monthInt: workDay.monthInt,
            dayInt: workDay.dayInt,
            startHour: workDay.startHour,
            startMinute: workDay.startMinute,
            endHour: workDay.endHour,
            endMinute: workDay.endMinute,
            spentHour: workDay.spentHour,
            hasDone: workDay.hasDone,
            workDayType: workDay.workDayType
        )
    }
    
    // TODO: - 날짜 struct 만들기
    func isToday(month: Int16, day: Int16) -> Bool {
        if month == Calendar.current.component(.month, from: Date()) {
            if day == Calendar.current.component(.day, from: Date()) {
                return true
            }
        }
        return false
    }
}

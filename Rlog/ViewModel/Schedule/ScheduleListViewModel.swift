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
    let year = Int(Calendar.current.component(.year, from: Date()))
    let month = Int(Calendar.current.component(.month, from: Date()))
    
    init() {
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.allWorkDays = CoreDataManager.shared.getWorkdaysByMonth(yearInt: self.year, monthInt: self.month)
            self.upcomingWorkDays = self.allWorkDays.filter { self.isUpcomingOrNotDone(hasDone: $0.hasDone, day: $0.dayInt) }
            self.pastWorkDays = self.allWorkDays.filter { !self.isUpcomingOrNotDone(hasDone: $0.hasDone, day: $0.dayInt) }
        }
    }
    
    // TODO: - 날짜 struct 만들기
    func isUpcomming(day: Int16) -> Bool {
        if day > Calendar.current.component(.day, from: Date()) {
            return true
        }
        return false
    }
    
    func isUpcomingOrNotDone(hasDone: Bool, day: Int16) -> Bool {
        if !hasDone || isUpcomming(day: day) {
            return true
        }
        return false
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
        if day > Calendar.current.component(.day, from: Date()) {
            return true
        }
        return false
    }
}

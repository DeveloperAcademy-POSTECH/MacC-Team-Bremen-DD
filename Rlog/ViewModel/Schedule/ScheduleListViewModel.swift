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
        fetchAllWorkDays()
    }
    
    func didSheetDismissed() {
        fetchAllWorkDays()
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
    
    // TODO: - 날짜 struct 만들기
    func isUpcomming(day: Int16) -> Bool {
        if day >= Calendar.current.component(.day, from: Date()) {
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
    var didDismiss: () -> Void
    var workDay: WorkDayEntity
    var isShowConfirmButton: Bool {
        if isToday(month: workDay.monthInt, day: workDay.dayInt) {
            return !workDay.hasDone
        }
        return false
    }
    let weekDay: Int16
    let yearInt: Int16
    let monthInt: Int16
    let dayInt: Int16
    let startTime: String
    let endTime: String
    let spentHour: Int16
    
    init(workDay: WorkDayEntity, didDismiss: @escaping () -> Void) {
        self.workDay = workDay
        weekDay = workDay.weekDay
        yearInt = workDay.yearInt
        monthInt = workDay.monthInt
        dayInt = workDay.dayInt
        startTime = workDay.startTime
        endTime = workDay.endTime
        spentHour = workDay.spentHour
        self.didDismiss = didDismiss
    }
    
    func didTapConfirmButton() {
        Task {
            try? await updateHasDone()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.disMiss, object: nil, userInfo: ["info":"dismiss"])
            }
        }
    }
}

private extension ScheduleCellViewModel {
    func updateHasDone() async throws {
        CoreDataManager.shared.editWorkday(of: workDay, weekDay: weekDay, yearInt: yearInt, monthInt: monthInt, dayInt: dayInt, startTime: startTime, endTime: endTime, spentHour: spentHour, hasDone: true)
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

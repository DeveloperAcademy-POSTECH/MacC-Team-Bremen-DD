//
//  MonthlyCalculateDetailViewModel.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/14.
//

import Foundation

@MainActor
final class MonthlyCalculateDetailViewModel: ObservableObject {
    var workspace: WorkspaceModel
    @Published var workdays: [WorkdayModel] = []
    @Published var calendarDays: [Date] = []
    @Published var emptyCalendarDays: [Int] = []

    @Published var startDate = Date()
    @Published var target = Date()

    let current = Date()

    init() {
        self.workspace = WorkspaceModel(payDay: 5)
        Task {
            await makeCalendarDates()
            makeEmptyCalendarDates()
        }
    }

    func calculateLeftDays() -> Int {
        let components = Calendar.current.dateComponents([.day], from: current, to: target)
        guard let leftDay = components.day else { return 0 }
        return leftDay
    }
}

private extension MonthlyCalculateDetailViewModel {
    func makeCalendarDates() async {
        let yearMonthDayFormatter = DateFormatter(dateFormatType: .yearMonthDay)
        let dayInt = current.dayInt
        let monthInt = current.monthInt
        let yearInt = current.yearInt

        var range = Date()

        if dayInt < workspace.payDay {
            let previousMonth = monthInt - 1
            let rangeString = "\(yearInt)/\(previousMonth)/\(workspace.payDay)"
            let targetString = "\(yearInt)/\(monthInt)/\(workspace.payDay)"
            range = yearMonthDayFormatter.date(from: rangeString)!
            target = yearMonthDayFormatter.date(from: targetString)!
            startDate = range
            print(range.fetchYearMonthDay())
            print(target.fetchYearMonthDay())
        } else {
            let nextMonth = monthInt + 1
            let rangeString = "\(yearInt)/\(monthInt)/\(workspace.payDay)"
            let targetString = "\(yearInt)/\(nextMonth)/\(workspace.payDay)"
            range = yearMonthDayFormatter.date(from: rangeString)!
            target = yearMonthDayFormatter.date(from: targetString)!
            startDate = range
            print(range.fetchYearMonthDay())
            print(target.fetchYearMonthDay())
        }

        while range < target {
            calendarDays.append(range)
            guard let next = Calendar.current.date(byAdding: DateComponents(day: 1), to: range) else { return }
            range = next
        }
    }

    func makeEmptyCalendarDates() {
        for count in 0..<startDate.weekDayInt - 1 {
            emptyCalendarDays.append(count)
        }
    }
}

struct WorkdayModel: Hashable {
    var date: Date
}

struct WorkspaceModel {
    var payDay: Int16
}


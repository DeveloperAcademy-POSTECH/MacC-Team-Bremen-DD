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
    var workdays: [WorkdayModel] = []
    var calendarDays: [Date] = []

    init() {
        self.workspace = WorkspaceModel(payDay: 20)
        makeCalendarDates()
    }

    func makeCalendarDates() {
        let yearMonthDayFormatter = DateFormatter(dateFormatType: .yearMonthDay)
        let current = Date()
        let dayInt = current.dayInt
        let monthInt = current.monthInt
        let yearInt = current.yearInt

        var range = Date()
        var target = Date()

        if dayInt < workspace.payDay {
            let previousMonth = monthInt - 1
            let rangeString = "\(yearInt)/\(previousMonth)/\(workspace.payDay)"
            let targetString = "\(yearInt)/\(monthInt)/\(workspace.payDay)"
            range = yearMonthDayFormatter.date(from: rangeString)!
            target = yearMonthDayFormatter.date(from: targetString)!
            print(range)
            print(target)
        } else {
            let nextMonth = monthInt + 1
            let rangeString = "\(yearInt)/\(monthInt)/\(workspace.payDay)"
            let targetString = "\(yearInt)/\(nextMonth)/\(workspace.payDay)"
            range = yearMonthDayFormatter.date(from: rangeString)!
            target = yearMonthDayFormatter.date(from: targetString)!
            print(range)
            print(target)
        }

        while range < target {
            calendarDays.append(range)
            guard let next = Calendar.current.date(byAdding: DateComponents(day: 1), to: range) else { return }
            range = next
        }
    }
}

struct WorkdayModel: Hashable {
    var date: Date
}

struct WorkspaceModel {
    var payDay: Int16
}


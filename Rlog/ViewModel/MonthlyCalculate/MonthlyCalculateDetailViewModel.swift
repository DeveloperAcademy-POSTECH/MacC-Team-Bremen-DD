//
//  MonthlyCalculateDetailViewModel.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/14.
//

import Foundation

@MainActor
final class MonthlyCalculateDetailViewModel: ObservableObject {
    let calculateResult: MonthlyCalculateResult
    @Published var calendarDays: [Date] = []
    @Published var emptyCalendarDays: [Int] = []

    @Published var startDate = Date()
    @Published var target = Date()

    let current = Date()

    init(calculateResult: MonthlyCalculateResult) {
        self.calculateResult = calculateResult
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
        let payDay = calculateResult.workspace.payDay
        var range = Date()

        if dayInt < payDay {
            let previousMonth = monthInt - 1
            let rangeString = "\(yearInt)/\(previousMonth)/\(payDay)"
            let targetString = "\(yearInt)/\(monthInt)/\(payDay)"
            range = yearMonthDayFormatter.date(from: rangeString)!
            target = yearMonthDayFormatter.date(from: targetString)!
            startDate = range
        } else {
            let nextMonth = monthInt + 1
            let rangeString = "\(yearInt)/\(monthInt)/\(payDay)"
            let targetString = "\(yearInt)/\(nextMonth)/\(payDay)"
            range = yearMonthDayFormatter.date(from: rangeString)!
            target = yearMonthDayFormatter.date(from: targetString)!
            startDate = range
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

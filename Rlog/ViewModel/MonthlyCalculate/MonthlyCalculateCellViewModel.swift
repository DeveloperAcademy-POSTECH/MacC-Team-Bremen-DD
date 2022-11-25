//
//  MonthlyCalculateCellViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/24.
//

import Foundation

@MainActor
final class MonthlyCalculateCellViewModel: ObservableObject {
    let workTypeManager = WorkTypeManager()

    let day: Date
    let workdays: [WorkdayEntity]
    @Published var workHours = 0
    @Published var workType: WorkDayType? = nil

    init(day: Date, workdays: [WorkdayEntity]) {
        self.day = day
        self.workdays = workdays
        self.workHours = calculateWorkHours()
        guard !workdays.isEmpty else { return }
        for workday in workdays {
            self.workType = workTypeManager.defineWorkType(workday: workday)
        }
    }
}

private extension MonthlyCalculateCellViewModel {
    func calculateWorkHours() -> Int {
        var total = 0
        for workday in workdays {
            let startTime = workday.startTime
            let endTime = workday.endTime
            let difference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            total += Int(difference) / 3600
        }
        return total
    }
}

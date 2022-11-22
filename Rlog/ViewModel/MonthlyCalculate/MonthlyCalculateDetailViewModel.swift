//
//  MonthlyCalculateDetailViewModel.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/14.
//

import Foundation

@MainActor
final class MonthlyCalculateDetailViewModel: ObservableObject {
    let workspace: WorkspaceModel
    let workdays: [WorkdayModel] = []
    let calendarDays: [Date] = []

    init() {
        self.workspace = WorkspaceModel(payDay: 25)
    }

    func makeCalendarDates() {
        let current = Date()
        

        var range = Date()
           guard let after5Month = Calendar.current.date(byAdding: DateComponents(month: 1), to: range) else { return }

           while range < after5Month {

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


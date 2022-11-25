//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

struct MonthlyCalculateResult {
    let workspace: WorkspaceEntity
    let date: Date
    var hasDoneWorkdays: [WorkdayEntity] {
        return getWorkdays(workspace: workspace, startDate: startDate, endDate: endDate)
    }
    var total: Int {
        return calculateTotal()
    }
    var totalWithoutTaxAndJuhu: Int {
        return calculateTotalWithoutTaxAndJuhu()
    }
    var workHours: Int {
        return calculateWorkHours()
    }
    var calculateTax: Int {
        return Int(Double(totalWithoutTaxAndJuhu) * 0.033)
    }
    var leftDays: Int {
        return calculateleftDays(workspace: workspace)
    }
    var startDate: Date {
        return getStartDate(workspace: workspace, date: date)
    }
    var endDate: Date {
        return getEndDate(workspace: workspace, date: date)
    }
    
    init(workspace: WorkspaceEntity, date: Date) {
        self.workspace = workspace
        self.date = date
    }
    
    private func calculateleftDays(workspace: WorkspaceEntity) -> Int {
        let currentDay = Calendar.current.component(.day, from: date)
        if Int(workspace.payDay) > currentDay {
            return Int(workspace.payDay) - currentDay
        } else {
            guard let nextMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: date) else { return 0 }
            
            let nextMonthYear = Calendar.current.component(.year, from: nextMonth)
            let nextMonthMonth = Calendar.current.component(.month, from: nextMonth)
            
            guard let nextPayDate = Calendar.current.date(from: DateComponents(year: nextMonthYear, month: nextMonthMonth, day: Int(workspace.payDay))) else { return 0 }
            let interval = nextPayDate.timeIntervalSince(date)
            
            return Int(interval / 86400) + 1
        }
    }
    
    private func getStartDate(workspace: WorkspaceEntity, date: Date) -> Date {
        if workspace.payDay >= Calendar.current.component(.day, from: date) {
            guard let lastMonth = Calendar.current.date(byAdding: DateComponents(month: -1), to: date) else { return Date() }
            
            guard let lastPayDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: lastMonth),
                month: Calendar.current.component(.month, from: lastMonth),
                day: Int(workspace.payDay))) else { return Date() }
            
            return lastPayDate
        } else {
            guard let payDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: date),
                month: Calendar.current.component(.month, from: date),
                day: Int(workspace.payDay)
            )) else { return Date() }
            
            return payDate
        }
    }
    
    private func getEndDate(workspace: WorkspaceEntity, date: Date) -> Date {
        if workspace.payDay >= Calendar.current.component(.day, from: date) {
            guard let payDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: date),
                month: Calendar.current.component(.month, from: date),
                day: Int(workspace.payDay) - 1
            )) else { return Date() }
            
            return payDate
        } else {
            guard let nextMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: date) else { return Date() }
            
            guard let nextPayDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: nextMonth),
                month: Calendar.current.component(.month, from: nextMonth),
                day: Int(workspace.payDay) - 1
            )) else { return Date() }
            
            return nextPayDate
        }
    }
    
    private func getWorkdays(workspace: WorkspaceEntity, startDate: Date, endDate: Date) -> [WorkdayEntity] {
        return CoreDataManager.shared.getHasDoneWorkdays(of: workspace, start: startDate, target: endDate)
    }
    
    private func calculateWorkHours() -> Int {
        var total = 0
        for workday in hasDoneWorkdays {
            let startTime = workday.startTime
            let endTime = workday.endTime
            let difference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            total += Int(difference) / 3600
        }
        return total
    }
    
    private func calculateTotalWithoutTaxAndJuhu() -> Int {
        var total = 0
        for workday in hasDoneWorkdays {
            let startTime = workday.startTime
            let endTime = workday.endTime
            let difference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            total += (Int(difference) / 3600 * Int(workday.hourlyWage))
        }
        return total
    }
    
    private func calculateTotal() -> Int {
        var total = totalWithoutTaxAndJuhu
        if workspace.hasTax {
            total -= calculateTax
        }
        return total
    }
}

@MainActor
final class MonthlyCalculateListViewModel: ObservableObject {
    let timeManager = TimeManager()
    let currentDate = Date()
    let workspaces: [WorkspaceEntity]
    
    @Published var switchedDate = Date()
    @Published var monthlyCalculateResults: [MonthlyCalculateResult] = []
    
    var total: Int {
        var total = 0
        for result in monthlyCalculateResults {
            total += result.total
        }
        return total
    }
    
    init() {
        let workspaces = CoreDataManager.shared.getAllWorkspaces()
        self.workspaces = workspaces
        for workspace in workspaces {
            monthlyCalculateResults.append(MonthlyCalculateResult(workspace: workspace, date: switchedDate))
        }
    }
    
    func didTapPreviousMonth() {
        switchedDate = timeManager.decreaseOneMonth(switchedDate)
        updateDate()
    }
    
    func didTapNextMonth() {
        switchedDate = timeManager.increaseOneMonth(switchedDate)
        updateDate()
    }
    
    func fetchIsCurrentMonth() -> Bool {
        return Calendar.current.component(.month, from: currentDate) == Calendar.current.component(.month, from: switchedDate)
    }
}

private extension MonthlyCalculateListViewModel {
    func updateDate() {
        monthlyCalculateResults = []
        for workspace in workspaces {
            monthlyCalculateResults.append(MonthlyCalculateResult(workspace: workspace, date: switchedDate))
        }
    }
}

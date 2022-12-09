//
//  MonthlyCalculateResult.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/25.
//

import Foundation

struct MonthlyCalculateResult {
    let workspace: WorkspaceEntity
    let currentMonth: Date
    
    var hasDoneWorkdays: [WorkdayEntity] {
        return getWorkdays(workspace: workspace, startDate: startDate, endDate: endDate)
    }
    var monthlySalary: Int {
        return calculateMonthlySalary()
    }
    var monthlySalaryWithoutTaxAndJuhyu: Int {
        return calculateMonthlySalaryWithoutTaxAndJuhu()
    }
    var workHours: Int {
        return calculateWorkHours()
    }
    var tax: Int {
        return Int(Double(monthlySalaryWithoutTaxAndJuhyu) * 0.033)
    }
    var juhyu: Int {
        return calculateJuhyu()
    }
    var leftDays: Int {
        return calculateleftDays(workspace: workspace)
    }
    var startDate: Date {
        return getStartDate(workspace: workspace, date: currentMonth)
    }
    var endDate: Date {
        return getEndDate(workspace: workspace, date: currentMonth)
    }
    
    init(workspace: WorkspaceEntity, date: Date) {
        self.workspace = workspace
        self.currentMonth = date
    }
    
    private func calculateleftDays(workspace: WorkspaceEntity) -> Int {
        let currentDay = Calendar.current.component(.day, from: currentMonth)
        if Int(workspace.payDay) > currentDay {
            return Int(workspace.payDay) - currentDay
        } else {
            guard let nextMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: currentMonth) else { return 0 }
            
            let nextMonthYear = Calendar.current.component(.year, from: nextMonth)
            let nextMonthMonth = Calendar.current.component(.month, from: nextMonth)
            
            guard let nextPayDate = Calendar.current.date(from: DateComponents(year: nextMonthYear, month: nextMonthMonth, day: Int(workspace.payDay))) else { return 0 }
            let interval = nextPayDate.timeIntervalSince(currentMonth)
            
            return Int(interval / 86400) + 1
        }
    }
    
    private func getStartDate(workspace: WorkspaceEntity, date: Date) -> Date {
        let previous = Date.decreaseOneMonth(currentMonth)
        return Calendar.current.date(bySetting: .day, value: Int(workspace.payDay), of: previous) ?? Date()
    }
    
    private func getEndDate(workspace: WorkspaceEntity, date: Date) -> Date {
        let previous = Date.decreaseOneMonth(currentMonth)
        let startDate = Calendar.current.date(bySetting: .day, value: Int(workspace.payDay), of: previous) ?? Date()
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? Date()
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
    
    private func calculateMonthlySalaryWithoutTaxAndJuhu() -> Int {
        var total = 0
        for workday in hasDoneWorkdays {
            let startTime = workday.startTime
            let endTime = workday.endTime
            let difference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            total += (Int(difference) / 3600 * Int(workday.hourlyWage))
        }
        return total
    }
    
    private func calculateMonthlySalary() -> Int {
        var total = monthlySalaryWithoutTaxAndJuhyu
        if workspace.hasTax {
            total -= tax
        }
        if workspace.hasJuhyu {
            total += juhyu
        }
        return total
    }
    
    private func calculateJuhyu() -> Int {
        return Int((Double(workspace.hourlyWage) * 1.2) * Double(workHours) - Double(monthlySalaryWithoutTaxAndJuhyu))
    }
}

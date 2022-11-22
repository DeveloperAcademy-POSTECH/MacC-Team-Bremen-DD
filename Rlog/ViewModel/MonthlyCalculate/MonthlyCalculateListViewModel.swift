//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

struct Calculate {
    let timeManager = TimeManager()
    let workspace: WorkspaceEntity
    
    var date: Date
    var hasDoneWorkdays: [WorkdayEntity] {
        return fetchWorkdays(workspace: workspace, date: date)
    }
    var total: Int {
        return totalWithoutTaxAndJuhu - calculateTax
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
//    var calculateJuhu: Int
    var leftDays: Int {
        return calculateleftDays(workspace: workspace)
    }
    
    init(workspace: WorkspaceEntity, date: Date) {
        self.workspace = workspace
        self.date = date
        
        
    }
    
    func calculateleftDays(workspace: WorkspaceEntity) -> Int {
        let currentDay = Calendar.current.component(.day, from: date)
        if Int(workspace.payDay) > currentDay {
            return Int(workspace.payDay) - currentDay
        } else {
            let nextMonth = timeManager.increaseOneMonth(date)
            
            let nextMonthYear = Calendar.current.component(.year, from: nextMonth)
            let nextMonthMonth = Calendar.current.component(.month, from: nextMonth)
            
            guard let nextPayDate = Calendar.current.date(from: DateComponents(year: nextMonthYear, month: nextMonthMonth, day: Int(workspace.payDay))) else {
                return 0
            }
            let interval = nextPayDate.timeIntervalSince(date)
            
            return Int(interval / 86400) + 1
        }
    }
    
    func fetchWorkdays(workspace: WorkspaceEntity, date: Date) -> [WorkdayEntity] {
        var hasDoneWorkdays: [WorkdayEntity] = []
        
        // payDay가 오늘 날짜보다 클 때와 작을 때를 다르게 계산해줘야 합니다(10월 10일 -> 15일일 때는 9월 16일 ~ 10월 15일, 5일 일때는 10월 5일 ~ 11월 4일치를 보여줘야 함
        if workspace.payDay < Calendar.current.component(.day, from: date) {
            guard let lastMonth = Calendar.current.date(byAdding: DateComponents(month: -1), to: date) else { return hasDoneWorkdays }
            
            guard let lastPayDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: lastMonth),
                month: Calendar.current.component(.month, from: lastMonth),
                day: Int(workspace.payDay)
            )), let payDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: date),
                month: Calendar.current.component(.month, from: date),
                day: Int(workspace.payDay)
            )) else { return hasDoneWorkdays }
            
            hasDoneWorkdays = CoreDataManager.shared.getHasDoneWorkdays(of: workspace, start: lastPayDate, target: payDate)
        } else {
            guard let nextMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: date) else { return hasDoneWorkdays }
            
            guard let nextPayDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: nextMonth),
                month: Calendar.current.component(.month, from: nextMonth),
                day: Int(workspace.payDay)
            )), let payDate = Calendar.current.date(from: DateComponents(
                year: Calendar.current.component(.year, from: date),
                month: Calendar.current.component(.month, from: date),
                day: Int(workspace.payDay)
            )) else { return hasDoneWorkdays }
            
            hasDoneWorkdays = CoreDataManager.shared.getHasDoneWorkdays(of: workspace, start: payDate, target: nextPayDate)
        }
        
        return hasDoneWorkdays
    }
    
    func calculateWorkHours() -> Int {
        var total = 0
        for workday in hasDoneWorkdays {
            let startTime = workday.startTime
            let endTime = workday.endTime
            let difference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            total += Int(difference) / 3600
        }
        return total
    }
    
    func calculateTotalWithoutTaxAndJuhu() -> Int {
        var total = 0
        for workday in hasDoneWorkdays {
            let startTime = workday.startTime
            let endTime = workday.endTime
            let difference = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            total += (Int(difference) / 3600 * Int(workday.hourlyWage))
        }
        return total
    }
}

final class MonthlyCalculateListViewModel: ObservableObject {
    let timeManager = TimeManager()
    
    @Published var currentDate = Date()
    @Published var switchedDate = Date()
    @Published var calculates: [Calculate] = []
    
    var total: Int {
        var total = 0
        for calculate in calculates {
            total += calculate.total
        }
        return total
    }
    
    init() {
        let workspaces = CoreDataManager.shared.getAllWorkspaces()
        for workspace in workspaces {
            calculates.append(Calculate(workspace: workspace, date: switchedDate))
        }
    }
    
    func onAppear() {
        getAllWorkspaces()
    }
    
    func didTapPreviousMonth() {
        switchedDate = timeManager.decreaseOneMonth(switchedDate)
    }
    
    func didTapNextMonth() {
        switchedDate = timeManager.increaseOneMonth(switchedDate)
    }
    
    func fetchIsCurrentMonth() -> Bool {
        return Calendar.current.component(.month, from: currentDate) == Calendar.current.component(.month, from: switchedDate)
    }
}

private extension MonthlyCalculateListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
    }
}

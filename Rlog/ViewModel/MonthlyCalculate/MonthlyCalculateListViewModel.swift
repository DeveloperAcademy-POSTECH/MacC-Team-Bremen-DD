//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

final class MonthlyCalculateListViewModel: ObservableObject {
    let timeManager = TimeManager()
    
    @Published var currentDate = Date()
    @Published var switchedDate = Date()
    @Published var workspaces: [WorkspaceEntity] = []
    
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
    
    func fetchRemainedDays(workspace: WorkspaceEntity) -> Int {
        return calculateRemainDays(workspace: workspace)
    }
}

private extension MonthlyCalculateListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        workspaces = result
    }
    
    func calculateRemainDays(workspace: WorkspaceEntity) -> Int {
        let currentDay = Calendar.current.component(.day, from: currentDate)
        if Int(workspace.payDay) > currentDay {
            return Int(workspace.payDay) - currentDay
        } else {
            let nextMonth = timeManager.increaseOneMonth(currentDate)
            
            let nextMonthYear = Calendar.current.component(.year, from: nextMonth)
            let nextMonthMonth = Calendar.current.component(.month, from: nextMonth)
            
            guard let nextPayDate = Calendar.current.date(from: DateComponents(year: nextMonthYear, month: nextMonthMonth, day: Int(workspace.payDay))) else {
                return 0
            }
            let interval = nextPayDate.timeIntervalSince(currentDate)
            
            return Int(interval / 86400) + 1
        }
    }
    
    func calculateWorkedHour(workspace: WorkspaceEntity) -> Int {
        
        
        let workdays = CoreDataManager.shared.getHasDoneWorkdays(of: workspace, start: <#T##Date#>, target: <#T##Date#>)
    }
}

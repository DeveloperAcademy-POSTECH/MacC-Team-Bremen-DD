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
    
//    var hasDoneWorkdays: [WorkdayEntity]
    var date: Date {
        didSet {
            print(date)
        }
    }
//    var total: Int
//    var workHours: Int
//    var calculateTax: Int
//    var calculateJuhu: Int
    var leftDays: Int {
        return calculateRemainDays(workspace: workspace)
    }
    
    init(workspace: WorkspaceEntity, date: Date) {
        self.workspace = workspace
        self.date = date
    }
    
    func calculateRemainDays(workspace: WorkspaceEntity) -> Int {
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
}

final class MonthlyCalculateListViewModel: ObservableObject {
    let timeManager = TimeManager()
    
    @Published var currentDate = Date()
    @Published var switchedDate = Date()
//    @Published var workspaces: [WorkspaceEntity] = []
    @Published var calculates: [Calculate] = []
    
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

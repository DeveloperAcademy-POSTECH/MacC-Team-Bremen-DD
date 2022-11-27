//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

@MainActor
final class MonthlyCalculateListViewModel: ObservableObject {
    let timeManager = TimeManager()
    let currentDate = Date()
    let workspaces: [WorkspaceEntity]
    
    @Published var switchedDate = Date()
    @Published var monthlyCalculateResults: [MonthlyCalculateResult] = []
    
    var monthlySalaryTotal: Int {
        var total = 0
        for result in monthlyCalculateResults {
            total += result.monthlySalary
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

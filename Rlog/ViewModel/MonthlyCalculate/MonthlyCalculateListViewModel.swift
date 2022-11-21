//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

final class MonthlyCalculateListViewModel: ObservableObject {
    let timeManager = TimeManager()
    
    @Published var date = Date()
    @Published var workspaces: [WorkspaceEntity] = []
    
    func onAppear() {
        getAllWorkspaces()
    }
    
    func didTapPreviousMonth() {
        date = timeManager.decreaseOneMonth(date)
    }
    
    func didTapNextMonth() {
        date = timeManager.increaseOneMonth(date)
    }
}

private extension MonthlyCalculateListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        workspaces = result
    }
}

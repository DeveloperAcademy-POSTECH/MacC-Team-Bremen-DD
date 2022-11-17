//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

@MainActor
final class MonthlyCalculateListViewModel: ObservableObject {
    @Published var date = Date()
    @Published var workspaces: [WorkspaceEntity] = []
    
    init() {
        getAllWorkspaces()
    }
}

private extension MonthlyCalculateListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
        }
    }
}

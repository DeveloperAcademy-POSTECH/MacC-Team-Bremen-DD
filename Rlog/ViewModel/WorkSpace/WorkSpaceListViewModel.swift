//
//  WorkSpaceListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

@MainActor
final class WorkSpaceListViewModel: ObservableObject {
    @Published var isShowingSheet = false
    @Published var workspaces: [WorkspaceEntity] = []
    
    init() {
        getAllWorkspaces()
    }
}

private extension WorkSpaceListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        workspaces = result
    }
}

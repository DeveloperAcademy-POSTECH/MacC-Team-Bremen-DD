//
//  WorkSpaceListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

@MainActor
final class WorkspaceListViewModel: ObservableObject {
    @Published var isShowingSheet = false
    @Published var workspaces: [WorkspaceEntity] = []
    
    func onAppear() {
        getAllWorkspaces()
    }
}

private extension WorkspaceListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        workspaces = result
    }
}

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
    @Published var isShowingSheet = false {
        didSet {
            getAllWorkspaces()
        }
    }
    @Published var workspaces: [WorkspaceEntity] = []
    
    func onAppear() {
        getAllWorkspaces()
    }
}

private extension WorkSpaceListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
        }
    }
}

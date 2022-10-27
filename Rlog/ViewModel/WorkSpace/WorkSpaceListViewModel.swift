//
//  WorkSpaceListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

final class WorkSpaceListViewModel: ObservableObject {
    @Published var workspaces: [WorkspaceEntity] = []
    @Published var schedules: [ScheduleEntity] = []
    @Published var isShowingSheet = false

    init() {
        getAllWorkspaces()
    }

    func didRecieveNotification() {
        getAllWorkspaces()
    }
}

// MARK: - Private Functions
private extension WorkSpaceListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
        }
    }
}

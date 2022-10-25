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
    @Published var isShowingSheet = false

    init() {
        getAllWorkspaces()
    }

    func didTapPlusButton() {
        isShowingSheet = true
    }

    func didDismissed() {
        getAllWorkspaces()
    }
}

extension WorkSpaceListViewModel {

   private func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
        }
    }

    private func createMockData() {
        CoreDataManager.shared.createWorkspace(name: "김씨네 편의점", hourlyWage: 9000, paymentDay: 10, colorString: WorkspaceColor.pink.name, hasTax: true, hasJuhyu: true)

        CoreDataManager.shared.createWorkspace(name: "김씨네 담배가게", hourlyWage: 9000, paymentDay: 10, colorString: WorkspaceColor.blue.name, hasTax: true, hasJuhyu: true)

        CoreDataManager.shared.createWorkspace(name: "김씨네 돈가스 가게", hourlyWage: 9000, paymentDay: 10, colorString: WorkspaceColor.red.name, hasTax: true, hasJuhyu: true)
    }
}

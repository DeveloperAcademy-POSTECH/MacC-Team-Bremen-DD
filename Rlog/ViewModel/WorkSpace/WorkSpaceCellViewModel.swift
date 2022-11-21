//
//  WorkSpaceCellViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/26.
//

import Foundation

@MainActor
final class WorkspaceCellViewModel: ObservableObject {
    var workspace: WorkspaceEntity
    
    @Published var schedules: [ScheduleEntity] = []
    
    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        getAllSchedules()
    }
}

private extension WorkspaceCellViewModel {
    func getAllSchedules() {
        let result = CoreDataManager.shared.getSchedules(of: workspace)
        self.schedules = result
    }
}

//
//  WorkSpaceCellViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/26.
//

import Foundation

@MainActor
final class WorkSpaceCellViewModel: ObservableObject {
    var workspace: WorkspaceEntity
    
    @Published var schedules: [ScheduleEntity] = []
    
    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        getAllSchedules()
    }
}

private extension WorkSpaceCellViewModel {
    func getAllSchedules() {
        let result = CoreDataManager.shared.getSchedules(of: workspace)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.schedules = result
        }
    }
}

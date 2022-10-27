//
//  WorkSpaceCellViewModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/26.
//

import Combine
import Foundation

final class WorkSpaceCellViewModel: ObservableObject {
    @Published var workspace: WorkspaceEntity
    @Published var schedules: [ScheduleEntity] = []

    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        getAllSchedules()
//        createMockSchedule()
    }

}

// MARK: - Private Functions
private extension WorkSpaceCellViewModel {
    func getAllSchedules() {
        let result = CoreDataManager.shared.getAllSchedules(of: workspace)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.schedules = result
        }
    }

    func createMockSchedule() {
        CoreDataManager.shared.createSchedule(of: workspace, repeatedSchedule: ["월", "수", "금"], startHour: 11, startMinute: 00, endHour: 12, endMinute: 00, spentHour: 1)
    }
}

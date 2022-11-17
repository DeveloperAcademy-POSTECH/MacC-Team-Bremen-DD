//
//  WorkSpaceDetailViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

@MainActor
final class WorkSpaceDetailViewModel: ObservableObject {
    var workspace: WorkspaceEntity
    
    @Published var name: String
    @Published var hourlyWageString: String
    @Published var paymentDayString: String
    @Published var hasTax: Bool
    @Published var hasJuhyu: Bool
    @Published var isAlertOpen = false
    @Published var isCreateScheduleModalShow = false
    @Published var schedules: [ScheduleEntity] = []
    
    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        self.name = workspace.name
        self.hourlyWageString = String(workspace.hourlyWage)
        self.paymentDayString = String(workspace.payDay)
        self.hasTax = workspace.hasTax
        self.hasJuhyu = workspace.hasJuhyu
    }
    
    func didTapConfirmButton(completion: @escaping (() -> Void)) {
        Task {
            await updateWorkspace()
            completion()
        }
    }
    
    func didTapDeleteButton(completion: @escaping (() -> Void)) {
        Task {
            await deleteWorkspace()
            completion()
        }
    }
    
    func onAppear() {
        getAllSchedules()
    }
}

private extension WorkSpaceDetailViewModel {
    func updateWorkspace() async {
        CoreDataManager.shared.editWorkspace(
            workspace: workspace,
            name: name,
            payDay: Int16(paymentDayString) ?? 1,
            hourlyWage: Int32(hourlyWageString) ?? 10000,
            hasTax: hasTax,
            hasJuhyu: hasJuhyu
        )
    }
    
    func deleteWorkspace() async {
        CoreDataManager.shared.deleteWorkspace(workspace: workspace)
    }
    
    func getAllSchedules() {
        let result = CoreDataManager.shared.getSchedules(of: workspace)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.schedules = result
        }
    }
}

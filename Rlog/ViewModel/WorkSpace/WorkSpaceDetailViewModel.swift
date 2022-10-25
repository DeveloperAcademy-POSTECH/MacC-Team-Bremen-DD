//
//  WorkSpaceDetailViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Combine
import Foundation

final class WorkSpaceDetailViewModel: ObservableObject {
    @Published var name: String
    @Published var hourlyWage: Int16
    @Published var paymentDay: Int16
    @Published var hasTax: Bool
    @Published var hasJuhyu: Bool

    var workspace: WorkspaceEntity

    init(workspace: WorkspaceEntity) {
        name = workspace.name
        hourlyWage = workspace.hourlyWage
        paymentDay = workspace.paymentDay
        hasTax = workspace.hasTax
        hasJuhyu = workspace.hasJuhyu
        self.workspace = workspace
    }

    func didTapCompleteButton(completion: @escaping (() -> Void)) {
        editWorkspace()
        completion()
    }

    func didTapDeleteButton(completion: @escaping (() -> Void)) {
        deleteWorkspace()
        completion()
    }
}

extension WorkSpaceDetailViewModel {
    private func editWorkspace() {
        CoreDataManager.shared.editWorkspace(
            workspace: workspace,
            name: name,
            hourlyWage: hourlyWage,
            paymentDay: paymentDay,
            colorString: workspace.colorString,
            hasTax: hasTax,
            hasJuhyu: hasJuhyu
        )
    }

    private func deleteWorkspace() {
        CoreDataManager.shared.deleteWorkspace(workspace: workspace)
    }
}

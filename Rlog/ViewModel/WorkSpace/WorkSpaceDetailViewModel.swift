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
    @Published var isAlertOpen: Bool

    @Published var hourlyWageString: String {
        didSet {
            self.hourlyWage = Int16(hourlyWageString) ?? 00
        }
    }
    @Published var paymentDayString: String {
        didSet {
            self.paymentDay = Int16(paymentDayString) ?? 00
        }
    }

    var workspace: WorkspaceEntity
    @Published var schedules: [ScheduleEntity]

    init(workspace: WorkspaceEntity, schedules: [ScheduleEntity]) {
        name = workspace.name
        hourlyWage = workspace.hourlyWage
        paymentDay = workspace.paymentDay
        hasTax = workspace.hasTax
        hasJuhyu = workspace.hasJuhyu
        self.workspace = workspace
        self.schedules = schedules
        paymentDayString = String(workspace.paymentDay)
        hourlyWageString = String(workspace.hourlyWage)
        isAlertOpen = false
    }

    func didTapCompleteButton(completion: @escaping (() -> Void)) {
        Task {
            await editWorkspace()
            completion()
        }
    }

    func didTapDeleteButton(completion: @escaping (() -> Void)) {
        Task {
            await deleteWorkspace()
            completion()
        }
    }

    func didTapScheduleDeleteButton(schedule: ScheduleEntity) {
        Task {
            await deleteSchedule(schedule: schedule)
            getAllSchedules()
        }
    }
}

// MARK: - Private Functions
private extension WorkSpaceDetailViewModel {
    func editWorkspace() async {
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

    func deleteWorkspace() async {
        CoreDataManager.shared.deleteWorkspace(workspace: workspace)
    }

    func deleteSchedule(schedule: ScheduleEntity) async {
        CoreDataManager.shared.deleteSchedule(of: schedule)
    }

    func getAllSchedules() {
        let result = CoreDataManager.shared.getAllSchedules(of: workspace)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.schedules = result
        }
    }
}

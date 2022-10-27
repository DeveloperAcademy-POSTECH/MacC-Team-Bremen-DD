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
    }

    func didTapCompleteButton(completion: @escaping (() -> Void)) {
        editWorkspace()
        completion()
    }

    func didTapDeleteButton(completion: @escaping (() -> Void)) {
        deleteWorkspace()
        completion()
    }

    func didTapScheduleDeleteButton(schedule: ScheduleEntity) {
        deleteSchedule(schedule: schedule) { [weak self] in
            guard let self = self else { return }
            self.getAllSchedules()
        }
    }
}

private extension WorkSpaceDetailViewModel {
    func editWorkspace() {
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

    func deleteWorkspace() {
        CoreDataManager.shared.deleteWorkspace(workspace: workspace)
    }

    func deleteSchedule(schedule: ScheduleEntity, completion: @escaping (() -> Void)) {
        CoreDataManager.shared.deleteSchedule(of: schedule)
        completion()
    }

    func getAllSchedules() {
        let result = CoreDataManager.shared.getAllSchedules(of: workspace)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.schedules = result
        }
    }
}

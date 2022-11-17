//
//  WorkSpaceCreateConfirmationViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/25.
//

import SwiftUI

@MainActor
final class WorkSpaceCreateConfirmationViewModel: ObservableObject {
    @Binding var isActiveNavigation: Bool
    
    var workspaceData: WorkSpaceModel
    var scheduleData: [ScheduleModel]
    
    init(isActiveNavigation: Binding<Bool>, workspaceData: WorkSpaceModel, scheduleData: [ScheduleModel]) {
        self._isActiveNavigation = isActiveNavigation
        self.workspaceData = workspaceData
        self.scheduleData = scheduleData
    }
    
    private let hasTax = false
    private let hasJuhyu = false
    
    func didTapConfirmButton() {
        Task {
            await createWorkspaceAndSchedule()
            popToRoot()
        }
    }
}

private extension WorkSpaceCreateConfirmationViewModel {
    func popToRoot() {
        self.isActiveNavigation = false
    }
    
    func calculateSpentHour(startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16) -> Double {
        let formatter = DateFormatter(dateFormatType: .timeAndMinute)
        
        let startDate = formatter.date(from: "\(startHour):\(startMinute)")
        let endDate = formatter.date(from: "\(endHour):\(endMinute)")
        
        guard let startDate = startDate,
              let endDate = endDate else { return 0.0 }
        
        let timeInterval = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        
        return (timeInterval / 3600)
    }
    
    func createWorkspaceAndSchedule() async {
        // TODO: - workspace create test용
        let workspaceEntity = CoreDataManager.shared.createWorkspace(
            name: workspaceData.name,
            payDay: Int16(workspaceData.paymentDay) ?? 0,
            hourlyWage: Int32(workspaceData.hourlyWage) ?? 0,
            hasTax: workspaceData.hasTax,
            hasJuhyu: workspaceData.hasJuhyu
        )
        for schedule in scheduleData  {
            CoreDataManager.shared.createSchedule(
                of: workspaceEntity,
                repeatDays: schedule.repeatedSchedule,
                startHour: Int16(schedule.startHour) ?? 0,
                startMinute: Int16(schedule.startMinute) ?? 0,
                endHour: Int16(schedule.endHour) ?? 0,
                endMinute: Int16(schedule.endMinute) ?? 0
            )
        }
    }
}


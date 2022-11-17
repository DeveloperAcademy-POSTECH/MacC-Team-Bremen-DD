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
            await createWorkSpace()
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
    
    func createWorkSpace() async {
        // TODO: - workspace create test용
        CoreDataManager.shared.createWorkspace(
            name: "GS25 포항공대점",
            payDay: Int16(10),
            hourlyWage: Int32(9160),
            hasTax: false,
            hasJuhyu: false
        )
    }
}


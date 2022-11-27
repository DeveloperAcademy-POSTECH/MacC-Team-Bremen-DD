//
//  WorkSpaceCreateScheduleListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/20.
//

import SwiftUI

@MainActor
final class WorkspaceCreateScheduleListViewModel: ObservableObject {
    @Binding var isActiveNavigation: Bool
    var workspaceModel: WorkSpaceModel
    init(isActiveNavigation: Binding<Bool>, workspaceModel: WorkSpaceModel) {
        self._isActiveNavigation = isActiveNavigation
        self.workspaceModel = workspaceModel
    }
    
    @Published var isShowingModal = false
    @Published var isDisabledNextButton = false
    
    @Published var scheduleList: [ScheduleModel] = [] {
        didSet {
            if !scheduleList.isEmpty {
                isDisabledNextButton = false
            }
        }
    }
    
    func didTapAddScheduleButton() {
        showModal()
    }
    func getScheduleData() -> [ScheduleModel] {
        return scheduleList
    }
    func didTapDeleteButton(idx: Int) {
        scheduleList.remove(at: idx)
    }
}

// MARK: - Private Functions
private extension WorkspaceCreateScheduleListViewModel {
    func showModal() {
        isShowingModal = true
    }
}

struct ScheduleModel: Hashable{
    var repeatedSchedule: [String] = []
    var startHour: Int16 = 0
    var startMinute: Int16 = 0
    var endHour: Int16 = 0
    var endMinute: Int16 = 0
}


struct WorkSpaceModel {
    var name: String
    var paymentDay: String
    var hourlyWage: String
    var hasTax: Bool
    var hasJuhyu: Bool
}

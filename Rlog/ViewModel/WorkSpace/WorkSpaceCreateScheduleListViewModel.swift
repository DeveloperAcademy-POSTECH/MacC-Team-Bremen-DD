//
//  WorkSpaceCreateScheduleListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/20.
//

import SwiftUI

@MainActor
final class WorkSpaceCreateScheduleListViewModel: ObservableObject {
    @Binding var isActiveNavigation: Bool
    let workspaceModel: WorkSpaceModel
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
private extension WorkSpaceCreateScheduleListViewModel {
    func showModal() {
        isShowingModal = true
    }
}

struct ScheduleModel: Hashable{
    var repeatedSchedule: [String] = []
    var startHour: String = ""
    var startMinute: String = ""
    var endHour: String = ""
    var endMinute: String = ""
}


struct WorkSpaceModel {
    let name: String
    let paymentDay: String
    let hourlyWage: String
    let hasTax: Bool
    let hasJuhyu: Bool
}

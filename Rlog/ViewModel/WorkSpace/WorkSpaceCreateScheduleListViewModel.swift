//
//  WorkSpaceCreateScheduleListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/20.
//

import SwiftUI

final class WorkSpaceCreateScheduleListViewModel: ObservableObject {
    @Binding var isActive: Bool
    let workspaceModel: WorkSpaceModel
    
    init(isActive: Binding<Bool>, workspaceModel: WorkSpaceModel) {
        self._isActive = isActive
        self.workspaceModel = workspaceModel
    }
    
    @Published var isShowingModal = false
    @Published var isDisabledNextButton = true
    
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
}

extension WorkSpaceCreateScheduleListViewModel {
    func showModal() {
        isShowingModal = true
    }
}

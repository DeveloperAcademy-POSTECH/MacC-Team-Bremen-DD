//
//  WorkSpaceCreateScheduleListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/20.
//

import SwiftUI

final class WorkSpaceCreateScheduleListViewModel: ObservableObject {
    @Binding var isActive: Bool
    var workspaceDatas: CreatingWorkSpaceModel
    
    init(isActive: Binding<Bool>, workspaceData: CreatingWorkSpaceModel) {
        self._isActive = isActive
        self.workspaceDatas = workspaceData
        print(workspaceData)
        
    }
    
    @Published var isShowingModal = false
    @Published var isDisabledNextButton = true
    
    @Published var scheduleList: [CreatingScheduleModel] = [] {
        didSet {
            if !scheduleList.isEmpty {
                isDisabledNextButton = false
            }
        }
    }
    
    func didTapAddScheduleButton() {
        showModal()
    }
    func getScheduleData() -> [CreatingScheduleModel] {
        return scheduleList
    }
}

extension WorkSpaceCreateScheduleListViewModel {
    func showModal() {
        isShowingModal = true
    }
}

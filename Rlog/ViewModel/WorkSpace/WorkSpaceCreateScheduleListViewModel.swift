//
//  WorkSpaceCreateScheduleListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/20.
//

import SwiftUI

final class WorkSpaceCreateScheduleListViewModel: ObservableObject {
    @Binding var isActive: Bool
    init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }
    
    @Published var isShowingModal = false
    @Published var isShowingConfirmButton = false
    
    @Published var scheduleList: [Schedule] = [] {
        didSet {
            if !scheduleList.isEmpty {
                isShowingConfirmButton = true
            }
            print("변경됨")
            isShowingConfirmButton = true
            print(isShowingConfirmButton)

        }
    }
    
    func didTapAddScheduleButton() {
        showModal()
    }
}

extension WorkSpaceCreateScheduleListViewModel {
    func showModal() {
        isShowingModal = true
    }
}

struct Schedule: Hashable{
    var repeatedSchedule: [String] = []
    var startHour: String = ""
    var startMinute: String = ""
    var endHour: String = ""
    var endMinute: String = ""
}

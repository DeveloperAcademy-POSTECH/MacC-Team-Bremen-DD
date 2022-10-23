//
//  WorkSpaceCreateScheduleListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/20.
//

import SwiftUI

final class WorkSpaceCreateScheduleListViewModel: ObservableObject {
    @Published var isNavigationActivated = false
    @Published var scheduleList: [Schedule] = []
    @Published var isShowingModal = false
    
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
    var workDays: [String] = []
    var startHour: String = ""
    var startMinute: String = ""
    var endHour: String = ""
    var endMinute: String = ""
}

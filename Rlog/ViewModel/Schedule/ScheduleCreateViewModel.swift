//
//  ScheduleCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Foundation
import SwiftUI

final class ScheduleCreateViewModel: ObservableObject {
    // TODO: - 현재 가지고 있는 workspace 받아오기
    let workspaces = ["제이든의 낚시 교실", "GS25 포항공대점", "제이든의 낚시 교실"]
    
    @Published var startHourText: String = ""
    @Published var startMinuteText: String = ""
    @Published var endHourText: String = ""
    @Published var endMinuteText: String = ""
    @Published var workspaceFlags: [Bool]
    @Published var reason = ""
    
    var confirmButtonForegroundColor: Color {
        if startHourText != "" && startMinuteText != "" && endHourText != "" && endMinuteText != "" {
            return Color.primary
        } else {
            return Color.fontLightGray
        }
    }
    
    init() {
        workspaceFlags = Array(repeating: false, count: workspaces.count)
    }
}

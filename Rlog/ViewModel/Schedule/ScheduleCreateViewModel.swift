//
//  ScheduleCreateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Foundation
import SwiftUI

final class ScheduleCreateViewModel: ObservableObject {
    @Published var startHourText: String = ""
    @Published var startMinuteText: String = ""
    @Published var endHourText: String = ""
    @Published var endMinuteText: String = ""
    @Published var workspaceFlags: [Bool] = []
    @Published var reason = ""
    @Published var workDate = Date()
    @Published var workspaces: [WorkspaceEntity] = []
    private var isNotEmpty: Bool {
        if startHourText != "" && startMinuteText != "" && endHourText != "" && endMinuteText != "" {
            return true
        } else {
            return false
        }
    }
    var confirmButtonForegroundColor: Color {
        if isNotEmpty {
            return Color.primary
        } else {
            return Color.fontLightGray
        }
    }
    
    init() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
            self.workspaceFlags = Array(repeating: false, count: result.count)
        }
    }
    
    func confirmButtonTapped() {
        if isNotEmpty {
            // TODO: - CoreData에 새 workday 생성
        }
    }
}

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
    @Published var isHideDatePicker = false
    var isEmpty: Bool {
        if startHourText == "" && startMinuteText == "" && endHourText == "" && endMinuteText == "" {
            return true
        } else {
            return false
        }
    }
    var confirmButtonForegroundColor: Color {
        if !isEmpty {
            return Color.primary
        } else {
            return Color.fontLightGray
        }
    }
    // TODO: - 업데이트된 모델에 맞게 수정(삭제)
    private var startTime: String {
        return "\(Int(startHourText)!):\(Int(startMinuteText)!)"
    }
    private var endTime: String {
        return "\(Int(endHourText)!):\(Int(endMinuteText)!)"
    }
    private var selectedWorkspace: WorkspaceEntity {
        for (index, flag) in workspaceFlags.enumerated() {
            if flag {
                return workspaces[index]
            }
        }
        return workspaces[0]
    }
    
    init() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
            self.workspaceFlags = Array(repeating: false, count: result.count)
        }
    }
    
    func didTapConfirmButton() async {
        try? await createWorkday()
    }
}

// TODO: - 요일 입력 수정
private extension ScheduleCreateViewModel {
    func createWorkday() async throws {
        CoreDataManager.shared.createWorkday(
            of: selectedWorkspace,
            weekDay: 0,
            yearInt: Int16(Calendar.current.component(.year, from: workDate)),
            monthInt: Int16(Calendar.current.component(.month, from: workDate)),
            dayInt: Int16(Calendar.current.component(.day, from: workDate)),
            startTime: startTime,
            endTime: endTime,
            spentHour: calculateSpentHour(startTime: startTime, endTime: endTime)
        )
    }
    
    func calculateSpentHour(startTime: String, endTime: String) -> Int16 {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startDate = formatter.date(from: startTime)
        let endDate = formatter.date(from: endTime)
        
        guard let startDate = startDate,
              let endDate = endDate else { return 0 }
        let timeInterval = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        
        return Int16(timeInterval / 3600)
    }
}

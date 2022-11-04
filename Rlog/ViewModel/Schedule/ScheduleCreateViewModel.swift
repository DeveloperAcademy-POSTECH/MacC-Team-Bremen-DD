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
    @Published var reason = ""
    @Published var workDate = Date()
    @Published var workspaces: [WorkspaceEntity] = [] {
        didSet {
            guard let selectedWorkspace = workspaces.first else { return }
            self.selectedWorkspace = selectedWorkspace
        }
    }
    @Published var selectedWorkspace: WorkspaceEntity?
    @Published var isHideDatePicker = false
    var hasFilled: Bool {
        if startHourText == "" || startMinuteText == "" || endHourText == "" || endMinuteText == "" {
            return true
        } else {
            return false
        }
    }
    var confirmButtonForegroundColor: Color {
        if !hasFilled {
            return Color.primary
        } else {
            return Color.fontLightGray
        }
    }
    private var startTime: String {
        return "\(Int(startHourText) ?? 12):\(Int(startMinuteText) ?? 0)"
    }
    private var endTime: String {
        return "\(Int(endHourText) ?? 13):\(Int(endMinuteText) ?? 0)"
    }
    
    init() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.workspaces = result
        }
    }
    
    func didTapConfirmButton() async {
        try? await createWorkday()
    }
    
    func fetchWorkspaceButtonBackground(compare: WorkspaceEntity) -> Color {
        return selectedWorkspace == compare ? Color.primary : Color(UIColor.systemGray6)
    }
    
    func fetchWorkspaceButtonFontColor(compare: WorkspaceEntity) -> Color {
        return selectedWorkspace == compare ? .white : Color.fontBlack
    }
}

// TODO: - 요일 입력 수정
private extension ScheduleCreateViewModel {
    func createWorkday() async throws {
        let workDay = WorkDay(
            weekDay: 0,
            yearInt: Int16(Calendar.current.component(.year, from: workDate)),
            monthInt: Int16(Calendar.current.component(.month, from: workDate)),
            dayInt: Int16(Calendar.current.component(.day, from: workDate)),
            startHour: Int16(startHourText) ?? 12,
            startMinute: Int16(startMinuteText) ?? 00,
            endHour: Int16(endHourText) ?? 13,
            endMinute: Int16(endMinuteText) ?? 00,
            hasDone: false,
            spentHour: calculateSpentHour(startTime: startTime, endTime: endTime),
            workDayType: 3
        )
        guard let selectedWorkspace = selectedWorkspace else { return }
        
        CoreDataManager.shared.createWorkday(
            of: selectedWorkspace,
            weekDay: workDay.weekDay,
            yearInt: workDay.yearInt,
            monthInt: workDay.monthInt,
            dayInt: workDay.dayInt,
            startHour: workDay.startHour,
            startMinute: workDay.startMinute,
            endHour: workDay.endHour,
            endMinute: workDay.endMinute,
            spentHour: workDay.spentHour,
            workDayType: 3
        )
    }
    
    // TODO: - 시간 관련 구조체로 이동
    func calculateSpentHour(startTime: String, endTime: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startDate = formatter.date(from: startTime)
        let endDate = formatter.date(from: endTime)
        
        guard let startDate = startDate, let endDate = endDate else { return 0 }
        let timeInterval = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        
        return timeInterval / 3600.0
    }
}

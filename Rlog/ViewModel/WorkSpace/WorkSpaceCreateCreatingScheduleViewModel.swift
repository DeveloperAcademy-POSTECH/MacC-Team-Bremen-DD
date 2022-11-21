//
//  WorkSpaceCreateCreatingScheduleViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

@MainActor
final class WorkspaceCreateCreatingScheduleViewModel: ObservableObject {
    @Binding var isShowingModal: Bool
    @Binding var scheduleList: [ScheduleModel]
    @Published var sevenDays: [SelectedDayModel] = SevenDays.allCases.map { $0.day }
    @Published var startTime: Date {
        didSet {
            startHour = Int16(timeManager.getHour(startTime))
            startMinute = Int16(timeManager.getMinute(startTime))
        }
    }
    @Published var endTime: Date {
        didSet {
            endHour = Int16(timeManager.getHour(endTime))
            endMinute = Int16(timeManager.getMinute(endTime))
        }
    }
    
    let timeManager = TimeManager()
    var isActivatedConfirmButton = false
    var errorMessage = ""
    var startHour: Int16 = 0
    var startMinute: Int16 = 0
    var endHour: Int16 = 0
    var endMinute: Int16 = 0
    
    init(isShowingModal: Binding<Bool>, scheduleList: Binding<[ScheduleModel]>) {
        self._isShowingModal = isShowingModal
        self._scheduleList = scheduleList
        self.startTime = timeManager.getDefaultStartTime()
        self.endTime = timeManager.getDefaultEndTime()
    }
    
    func didTapDayPicker(index: Int) {
        checkAllInputFilled(index)
    }
    
    func didTapConfirmButton() {
        appendScheduleToList()
        dismissModal()
    }
}

// MARK: - Private Functions
private extension WorkspaceCreateCreatingScheduleViewModel {
    func appendScheduleToList() {
        scheduleList.append(
            ScheduleModel(
                repeatedSchedule: self.getDayList(),
                startHour: self.startHour,
                startMinute: self.startMinute,
                endHour: self.endHour,
                endMinute: self.endMinute
            )
        )
    }
    
    func dismissModal() {
        isShowingModal = false
    }
    
    func getDayList() -> [String] {
        var dayList: [String] = []
        for day in sevenDays {
            if day.isSelected {
                dayList.append(day.dayName)
            }
        }
        return dayList
    }
    
    func checkAllInputFilled(_ index: Int) {
        sevenDays[index].isSelected.toggle()
        let selectedArray = sevenDays.filter { $0.isSelected == true }
        if selectedArray.isEmpty {
            isActivatedConfirmButton = false
        } else {
            isActivatedConfirmButton = true
        }
    }
}

struct SelectedDayModel: Hashable {
    let dayName: String
    var isSelected: Bool
}

fileprivate enum SevenDays: CaseIterable {
    case mon, tues, wed, thurs, fri, sat, sun
    
    var day: SelectedDayModel {
        switch self {
        case .mon:
            return SelectedDayModel(dayName: "월", isSelected: false)
        case .tues:
            return SelectedDayModel(dayName: "화", isSelected: false)
        case .wed:
            return SelectedDayModel(dayName: "수", isSelected: false)
        case .thurs:
            return SelectedDayModel(dayName: "목", isSelected: false)
        case .fri:
            return SelectedDayModel(dayName: "금", isSelected: false)
        case .sat:
            return SelectedDayModel(dayName: "토", isSelected: false)
        case .sun:
            return SelectedDayModel(dayName: "일", isSelected: false)
        }
    }
}

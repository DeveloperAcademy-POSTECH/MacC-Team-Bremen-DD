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
    @Published var isStartTimePickerActive = false {
        willSet {
            if newValue == true {
                withAnimation { self.isEndTimePickerActive = false }
            }
        }
    }
    @Published var isEndTimePickerActive = false {
        willSet {
            if newValue == true {
                withAnimation { self.isStartTimePickerActive = false }
            }
        }
    }
    @Published var startTime: Date {
        didSet {
            startHour = Int16(startTime.hourInt)
            startMinute = Int16(startTime.minuteInt)
        }
    }
    @Published var endTime: Date {
        didSet {
            endHour = Int16(endTime.hourInt)
            endMinute = Int16(endTime.minuteInt)
        }
    }
    @Published var isAlertActive = false
    
    var isActivatedConfirmButton = false
    var errorMessage = ""
    var startHour: Int16 = 9
    var startMinute: Int16 = 0
    var endHour: Int16 = 18
    var endMinute: Int16 = 0
    
    init(isShowingModal: Binding<Bool>, scheduleList: Binding<[ScheduleModel]>) {
        self._isShowingModal = isShowingModal
        self._scheduleList = scheduleList
        self.startTime = Date.getDefaultStartTime()
        self.endTime = Date.getDefaultEndTime()
    }
    
    func didTapDayPicker(index: Int) {
        checkAllInputFilled(index)
    }
    
    func didTapConfirmButton() {
        if isActivatedConfirmButton {
            if !checkScheduleConflict(creatSchedules: scheduleList) {
                appendScheduleToList()
                dismissModal()
            } else {
                isAlertActive.toggle()
            }
        }
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
    
    func checkScheduleConflict(creatSchedules: [ScheduleModel]) -> Bool {
        for creatSchedule in creatSchedules {
            for day in sevenDays {
                if day.isSelected {
                    if creatSchedule.repeatedSchedule.contains(day.dayName) {
                        return true
                    }
                }
            }
        }
        return false
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

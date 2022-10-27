//
//  WorkSpaceCreateCreatingScheduleViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

final class WorkSpaceCreateCreatingScheduleViewModel: ObservableObject {
    @Binding var isShowingModal: Bool
    @Binding var scheduleList: [ScheduleModel]
    
    var isShowingConfirmButton = false
    var errorMessage = ""
    
    // 어떻게 더 깔끔하게 짤 수 있을까요? enum을 사용하면 깔끔해질까요?
    @Published var sevenDays: [selectedDayModel] = [
        selectedDayModel(dayName: "월", isSelected: false),
        selectedDayModel(dayName: "화", isSelected: false),
        selectedDayModel(dayName: "수", isSelected: false),
        selectedDayModel(dayName: "목", isSelected: false),
        selectedDayModel(dayName: "금", isSelected: false),
        selectedDayModel(dayName: "토", isSelected: false),
        selectedDayModel(dayName: "일", isSelected: false)
    ]
    
    @Published var startHour = "" {
        didSet {
            if Int(startHour) ?? 0 > 24 {
                startHour = oldValue
                errorMessage = "24시간을 초과한 값을 넣을 수 없습니다."
                isShowingConfirmButton = false
            } else {
                errorMessage = ""
                checkAllInputFilled()
            }
        }
    }

    @Published var startMinute = "" {
        didSet {
            if Int(startMinute) ?? 0 > 59 {
                startMinute = oldValue
                errorMessage = "59분을 초과한 값을 넣을 수 없습니다."
                isShowingConfirmButton = false
            } else {
                errorMessage = ""
            }
        }
    }

    @Published var endHour = "" {
        didSet {
            guard let endHour = Int(endHour) else { return }
            if endHour > 24 {
                self.endHour = oldValue
                errorMessage = "24시간을 초과한 값을 넣을 수 없습니다."
                isShowingConfirmButton = false
            } else if Int(startHour) ?? 0 > endHour {
                errorMessage = "출근시간 보다 퇴근시간이 빠릅니다"
                isShowingConfirmButton = false
            } else {
                errorMessage = ""
                checkAllInputFilled()
            }
        }
    }

    @Published var endMinute = "" {
        didSet {
            if Int(endMinute) ?? 0 > 59 {
                endMinute = oldValue
                errorMessage = "59분을 초과한 값을 넣을 수 없습니다."
                isShowingConfirmButton = false
            } else {
                errorMessage = ""
            }
        }
    }
    
    init(isShowingModal: Binding<Bool>, scheduleList: Binding<[ScheduleModel]>) {
        self._isShowingModal = isShowingModal
        self._scheduleList = scheduleList
    }
    
    func didTapDayPicker(index: Int) {
        sevenDays[index].isSelected.toggle()
        checkAllInputFilled()
    }

    func didTapConfirmButton() {
        Task {
            await appendScheduleToList()
            await dismissModal()
        }
    }
}

private extension WorkSpaceCreateCreatingScheduleViewModel {

    @MainActor
    func appendScheduleToList() async {
        if startMinute.isEmpty {
            startMinute = "00"
        }
        if endMinute.isEmpty {
            endMinute = "00"
        }
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

    @MainActor
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

    func checkAllInputFilled() {
        if !startHour.isEmpty && !endHour.isEmpty && startHour != endHour && !getDayList().isEmpty {
            isShowingConfirmButton = true
            return
        }
        isShowingConfirmButton = false
    }
}

struct selectedDayModel: Hashable {
    let dayName: String
    var isSelected: Bool
}

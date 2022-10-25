//
//  WorkSpaceCreateCreatingScheduleViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

final class WorkSpaceCreateCreatingScheduleViewModel: ObservableObject {
    @Binding var isShowingModal: Bool
    @Binding var scheduleList: [Schedule]
    
    @Published var isShowingConfirmButton = false
    @Published var isShowingOverSingleDay = false
    @Published var errorMessage = ""
    
    // 어떻게 더 깔끔하게 짤 수 있을까요? enum을 사용하면 깔끔해질까요?
    @Published var sevenDays: [selectedDayModel] = [selectedDayModel(dayName: "월", isSelected: false), selectedDayModel(dayName: "화", isSelected: false), selectedDayModel(dayName: "수", isSelected: false), selectedDayModel(dayName: "목", isSelected: false), selectedDayModel(dayName: "금", isSelected: false), selectedDayModel(dayName: "토", isSelected: false), selectedDayModel(dayName: "일", isSelected: false)]
    
    @Published var startHour = "" {
        didSet {
            
            if Int(startHour) ?? 0 > 24 {
                startHour = oldValue
                errorMessage = "24시간을 초과한 값을 넣을 수 없습니다."
            } else {
                errorMessage = ""
            }
            checkAllInputFilled()
            checkIsOverSingleDay()
        }
    }
    @Published var startMinute = "" {
        didSet {
            if Int(startMinute) ?? 0 > 59 {
                startMinute = oldValue
                errorMessage = "59분을 초과한 값을 넣을 수 없습니다."
            } else {
                errorMessage = ""
            }
        }
    }
    @Published var endHour = "" {
        didSet {
            if Int(endHour) ?? 0 > 24 {
                endHour = oldValue
                errorMessage = "24시간을 초과한 값을 넣을 수 없습니다."
            } else {
                errorMessage = ""
            }
            checkAllInputFilled()
            checkIsOverSingleDay()
        }
    }
    @Published var endMinute = "" {
        didSet {
            if Int(endMinute) ?? 0 > 59 {
                endMinute = oldValue
                errorMessage = "59분을 초과한 값을 넣을 수 없습니다."
            } else {
                errorMessage = ""
            }
        }
    }
    
    init(isShowingModal: Binding<Bool>, scheduleList: Binding<[Schedule]>) {
        self._isShowingModal = isShowingModal
        self._scheduleList = scheduleList
    }
    
    func didTapDayPicker(index: Int) {
        sevenDays[index].isSelected.toggle()
        checkAllInputFilled()
    }
    func didTapConfirmButton() {
        appendScheduleToList()
        dismissModal()
    }
}

extension WorkSpaceCreateCreatingScheduleViewModel {
    func checkIsOverSingleDay() {
        if !startHour.isEmpty && !endHour.isEmpty  {
            if Int(startHour) ?? 0 >= Int(endHour) ?? 0 {
                isShowingOverSingleDay = true
                return
            }
        }
        isShowingOverSingleDay = false

    }
    func appendScheduleToList() {
        if startMinute.isEmpty {
            startMinute = "00"
        }
        if endMinute.isEmpty {
            endMinute = "00"
        }
        scheduleList.append(Schedule(repeatedSchedule: getDayList() ,startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute))
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

struct DayButtonSubView: View {
    
    let day: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.accentColor)
                .opacity(isSelected ? 1 : 0)
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(red: 0.769, green: 0.769, blue: 0.769), lineWidth: 1)
                .opacity(isSelected ? 0 : 1)
            Text(day)
                .foregroundColor(isSelected ? .white : .fontBlack)
        }
        .frame(height: 60)
    }
}

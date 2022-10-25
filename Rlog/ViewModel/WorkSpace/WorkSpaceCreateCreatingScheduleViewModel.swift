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
    
    // 어떻게 더 깔끔하게 짤 수 있을까요? enum을 사용하면 깔끔해질까요?
    @Published var sevenDays: [selectedDayModel] = [selectedDayModel(dayName: "월", isSelected: false), selectedDayModel(dayName: "화", isSelected: false), selectedDayModel(dayName: "수", isSelected: false), selectedDayModel(dayName: "목", isSelected: false), selectedDayModel(dayName: "금", isSelected: false), selectedDayModel(dayName: "토", isSelected: false), selectedDayModel(dayName: "일", isSelected: false)]
    
    @Published var startHour = "" {
        didSet {
            // TODO: 입력값이 24시간을 넘어가면 경고처리 하기
            checkAllInputFilled()
        }
    }
    @Published var startMinute = ""
    @Published var endHour = "" {
        didSet {
            // TODO: 입력값이 24시간을 넘어가면 경고처리 하기
            checkAllInputFilled()
        }
    }
    @Published var endMinute = ""
    
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
    
    func appendScheduleToList() {
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

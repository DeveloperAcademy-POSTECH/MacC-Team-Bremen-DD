//
//  WorkSpaceCreateCreatingScheduleViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

final class WorkSpaceCreateCreatingScheduleViewModel: ObservableObject {
    // 어떻게 더 깔끔하게 짤 수 있을까요? enum을 사용하면 깔끔해질까요?
    @Published var sevenDays: [selectedDayModel] = [selectedDayModel(dayName: "월", isSelected: false), selectedDayModel(dayName: "화", isSelected: false), selectedDayModel(dayName: "수", isSelected: false), selectedDayModel(dayName: "목", isSelected: false), selectedDayModel(dayName: "금", isSelected: false), selectedDayModel(dayName: "토", isSelected: false), selectedDayModel(dayName: "일", isSelected: false)]
    @Published var startHour = ""
    @Published var startMinute = ""
    @Published var endHour = ""
    @Published var endMinute = ""
    

    // let dayList = ["월","화","수","목","금","토","일"]
    func didTapDayPicker(index: Int) {
        sevenDays[index].isSelected.toggle()
    } 

}
struct selectedDayModel: Hashable {
    let dayName: String
    var isSelected: Bool
}

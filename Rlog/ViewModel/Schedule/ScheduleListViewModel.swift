//
//  MonthlyCalculateListViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum ScheduleCase: String, CaseIterable {
    case upcoming = "예정된 일정"
    case past = "지나간 일정"
}

final class ScheduleListViewModel: ObservableObject {
    @Published var selectedScheduleCase: ScheduleCase = .upcoming
    let yearAndMonth: String = Date().fetchYearAndMonth()
}

final class StatusPickerViewModel: ObservableObject {
    @Binding var selectedScheduleCase: ScheduleCase
    let scheduleCases = ScheduleCase.allCases
    var statusPickerOffset: CGFloat {
        selectedScheduleCase == .upcoming ? -40 : 40
    }
    
    init(selectedScheduleCase: Binding<ScheduleCase>) {
        self._selectedScheduleCase = selectedScheduleCase
    }
    
    func getStatusPickerTextWeight(compareCase: ScheduleCase) -> Font.Weight {
        return selectedScheduleCase == compareCase ? Font.Weight.bold : Font.Weight.regular
    }
    
    func getStatusPickerForegroundColor(compareCase: ScheduleCase) -> Color {
        return selectedScheduleCase == compareCase ? .white : Color.fontLightGray
    }
}

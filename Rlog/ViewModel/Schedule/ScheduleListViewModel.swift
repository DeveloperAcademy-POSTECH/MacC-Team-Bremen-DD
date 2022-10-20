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

class ScheduleListViewModel: ObservableObject {
    var scheduleCases = ScheduleCase.allCases
    
    func setCustomPickerOffset(currentCase: ScheduleCase) -> CGFloat {
        return currentCase == .upcoming ? -40 : 40
    }
    
    func setCustomPickerRectangleWidth(currentCase: ScheduleCase, compareCase: ScheduleCase) -> CGFloat {
        return currentCase == compareCase ? 97 : 176 - 97
    }
    
    func setCustomPickerTextWeight(currentCase: ScheduleCase, compareCase: ScheduleCase) -> Font.Weight {
        return currentCase == compareCase ? Font.Weight.bold : Font.Weight.regular
    }
    
    func setCustomPickerForegroundColor(currentCase: ScheduleCase, compareCase: ScheduleCase) -> Color {
        return currentCase == compareCase ? .white : Color.fontLightGray
    }
}

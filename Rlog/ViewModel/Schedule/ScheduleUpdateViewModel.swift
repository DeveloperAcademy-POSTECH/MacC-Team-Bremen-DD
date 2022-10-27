//
//  ScheduleUpdateViewModel.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import Foundation
import SwiftUI

enum TimeUnit: String, CaseIterable {
    case minusOneHour = "-1시간"
    case minusHalfHour = "-30분"
    case plusHalfHour = "+30분"
    case plusOneHour = "+1시간"
}

final class ScheduleUpdateViewModel: ObservableObject {
    @Published var workDay: WorkDayEntity
    @Published var reason = ""
    
    init(workDay: WorkDayEntity) {
        self.workDay = workDay
    }
}

final class TimeEditerViewModel: ObservableObject {
    @Binding var time: String
    
    init(time: Binding<String>) {
        self._time = time
    }
}


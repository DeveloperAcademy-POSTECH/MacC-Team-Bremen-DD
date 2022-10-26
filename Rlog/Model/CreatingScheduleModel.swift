//
//  Schedule.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/25.
//

import Foundation


struct ScheduleModel: Hashable{
    var repeatedSchedule: [String] = []
    var startHour: String = ""
    var startMinute: String = ""
    var endHour: String = ""
    var endMinute: String = ""
}

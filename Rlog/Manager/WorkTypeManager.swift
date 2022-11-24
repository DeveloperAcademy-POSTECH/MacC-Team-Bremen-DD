//
//  WorkTypeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/24.
//

import SwiftUI

final class WorkTypeManager {
    let timeManager = TimeManager()
    
    // 판단하고자 하는 일정의 WorkdayEntity를 파라미터로 받습니디.
    // (title, color) 형태로 반환
    // 추가, 축소, 연장과 같은 근무 유형이 String으로 반환합니다.
    // 유형에 따른 고유 색상을 Color 형태로 반환합니다.
    func defineWorkType(data: WorkdayEntity) -> (title: String, color: Color) {
        guard
            let repeatDays = data.schedule?.repeatDays,
            let startHour = data.schedule?.startHour,
            let startMinute = data.schedule?.startMinute,
            let endHour = data.schedule?.endHour,
            let endMinute = data.schedule?.endMinute
        else { return ("추가", Color.pointPurple) }
        let weekday = timeManager.getWeekdayOfDate(data.date)
        let normalSpentHour = data.endTime - data.startTime
        guard let spentHour = timeManager.calculateTimeGap(
            startHour: startHour,
            startMinute: startMinute,
            endHour: endHour,
            endMinute: endMinute
        ) else { return ("오류", .black) }

        if repeatDays.contains(weekday), normalSpentHour == spentHour {
            return ("정규", Color.primary)
        }

        switch spentHour  {
        case 1...:
            return ("연장", Color.pointBlue)
        case _ where spentHour < 0:
            return ("축소", Color.pointRed)
        default:
            return ("오류", .black)
        }
    }
}

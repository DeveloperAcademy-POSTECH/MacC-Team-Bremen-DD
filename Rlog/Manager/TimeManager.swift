//
//  TimeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/16.
//

import Foundation

// TODO: 삭제 필요🔥 날짜 핸들링을 위해 임시로 세팅해둔 모델입니다. 현재 대체 작업 중에 있습니다.
// Sample calendar model
struct CalendarModel {
    let year: Int
    let month: Int
    let day: Int
}

final class TimeManager {
    private let calendar = Calendar.current
    private let formatter = DateFormatter(dateFormatType: .weekday)
    
    // 1주 증가
    func increaseOneWeek(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .weekOfMonth, value: 1, to: date)
        else { return Date() }
        
        return date
    }
    
    // 1주 감소
    func decreaseOneWeek(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .weekOfMonth, value: -1, to: date)
        else { return Date() }
        
        return date
    }
    
    // 1개월 증가
    func increaseOneMonth(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .month, value: 1, to: date)
        else { return Date()}
        
        return date
    }
    
    // 1개월 감소
    func decreaseOneMonth(_ date: Date) -> Date {
        guard let date = calendar.date(byAdding: .month, value: -1, to: date)
        else { return Date() }
        
        return date
    }
    
    // 해당 날짜의 요일 String 반환
    func getWeekdayOfDate(_ date: Date) -> String {
        let weekday = formatter.string(from: date)
        
        return weekday
    }
    
    func getHourAndMinute(_ date: Date) -> (hour: Int, minute: Int) {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 9
        let minute = components.minute ?? 0
        
        return (hour, minute)
    }
    
    func calculateTimeGap(startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16) -> Double? {
        guard
            let startTime = calendar.date(bySettingHour: Int(startHour), minute: Int(startMinute), second: 0, of: Date()),
            let endTime = calendar.date(bySettingHour: Int(endHour), minute: Int(endMinute), second: 0, of: Date())
        else { return nil }
        
        let gap = endTime - startTime
        
        return gap
    }

    func calculateTimeGapBetweenTwoDate(start: Date, end: Date) -> Double {
         return end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
     }
    
    func secondsToHoursMinutesSeconds(_ seconds: Double) -> (Int, Int, Int) {
        let time = Int(seconds)
        return (time / 3600, (time % 3600) / 60, (time % 3600) % 60)
    }
}

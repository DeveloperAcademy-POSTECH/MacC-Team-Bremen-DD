//
//  TimeManager.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/16.
//

import Foundation

final class TimeManager {
    let calendar = Calendar.current
    let formatter = DateFormatter(dateFormatType: .weekday)
    
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
    
    // 오전 9시를 반환합니다 - BorderedPicker 전용
    func getDefaultStartTime() -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 2000
        let month = components.month ?? 1
        let day = components.day ?? 1
        let startOfToday = DateComponents(year: year, month: month, day: day, hour: 9, minute: 0)
        let date = calendar.date(from: startOfToday) ?? Date()

        return date
    }
    
    // 오후 6시를 반환합니다 - BorderedPicker 전용
    func getDefaultEndTime() -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 2000
        let month = components.month ?? 1
        let day = components.day ?? 1
        let startOfToday = DateComponents(year: year, month: month, day: day, hour: 18, minute: 0)
        let date = calendar.date(from: startOfToday) ?? Date()

        return date
    }
    
    func getHour(_ date: Date) -> Int {
        let components = calendar.dateComponents([.hour], from: date)
        let hour = components.hour ?? 9
        
        return hour
    }
    
    func getMinute(_ date: Date) -> Int {
        let components = calendar.dateComponents([.minute], from: date)
        let minute = components.minute ?? 9
        
        return minute
    }
}

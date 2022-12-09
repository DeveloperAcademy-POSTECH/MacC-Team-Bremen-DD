//
//  Date+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation

extension Date {
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }
    
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var yearInt: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var weekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let converted = dateFormatter.string(from: self)
        return converted
    }
    
    var weekDayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var hourInt: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minuteInt: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var nextDate: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var previousDate: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func fetchMonthDay() -> String {
        let dateFormatter = DateFormatter(dateFormatType: .monthDayKR)
        let converted = dateFormatter.string(from: self)
        return converted
    }
    
    // 시간, 분까지 고려한 날짜 차이 계산
    // https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    // 1주 증가
    static func increaseOneWeek(_ date: Date) -> Date {
        guard let date = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: date)
        else { return Date() }
        
        return date
    }
    
    // 1주 감소
    static func decreaseOneWeek(_ date: Date) -> Date {
        guard let date = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: date)
        else { return Date() }
        
        return date
    }
    
    // 1개월 증가
    static func increaseOneMonth(_ date: Date) -> Date {
        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: date)
        else { return Date()}
        
        return date
    }
    
    // 1개월 감소
    static func decreaseOneMonth(_ date: Date) -> Date {
        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: date)
        else { return Date() }
        
        return date
    }
    
    static func getHourAndMinute(_ date: Date) -> (hour: Int, minute: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 9
        let minute = components.minute ?? 0
        
        return (hour, minute)
    }
    
    static func calculateTimeGap(startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16) -> Double? {
        if startHour < endHour {
            guard
                let startTime = Calendar.current.date(bySettingHour: Int(startHour), minute: Int(startMinute), second: 0, of: Date()),
                let endTime = Calendar.current.date(bySettingHour: Int(endHour), minute: Int(endMinute), second: 0, of: Date())
            else { return nil }
            
            let gap = endTime - startTime
            
            return gap
        } else {
            guard
                let startTime = Calendar.current.date(bySettingHour: Int(startHour), minute: Int(startMinute), second: 0, of: Date()),
                let endTime = Calendar.current.date(bySettingHour: Int(endHour), minute: Int(endMinute), second: 0, of: Date()),
                let endTimePlus1Day = Calendar.current.date(byAdding: DateComponents(day: 1), to: endTime)
            else { return nil }
            
            let gap = endTimePlus1Day - startTime
            
            return gap
        }
    }
    
    static func calculateTimeGapBetweenTwoDate(start: Date, end: Date) -> Double {
        return end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
    }
    
    static func secondsToHoursMinutesSeconds(_ seconds: Double) -> (Int, Int, Int) {
        let time = Int(seconds)
        return (time / 3600, (time % 3600) / 60, (time % 3600) % 60)
    }
    
    static func compareDate(date1: Date, date2: Date, unit: Calendar.Component) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: unit)
        switch order {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    
    // 오전 9시를 반환합니다 - BorderedPicker 전용
    static func getDefaultStartTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 2000
        let month = components.month ?? 1
        let day = components.day ?? 1
        let startOfToday = DateComponents(year: year, month: month, day: day, hour: 9, minute: 0)
        let date = Calendar.current.date(from: startOfToday) ?? Date()

        return date
    }
    
    // 오후 6시를 반환합니다 - BorderedPicker 전용
    static func getDefaultEndTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 2000
        let month = components.month ?? 1
        let day = components.day ?? 1
        let startOfToday = DateComponents(year: year, month: month, day: day, hour: 18, minute: 0)
        let date = Calendar.current.date(from: startOfToday) ?? Date()

        return date
    }
}

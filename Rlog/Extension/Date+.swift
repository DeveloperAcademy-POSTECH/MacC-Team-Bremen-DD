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

    var weekDayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }

    var previousDate: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    // 시간, 분까지 고려한 날짜 차이 계산
    // https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    // TODO: - DateFormatter+ 구현 후 삭제
    func fetchYearAndMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        return dateFormatter.string(from: self)
    }
    
    func fetchDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let converted = dateFormatter.string(from: date)
        return converted
    }

    func fetchYearMonthDay() -> String {
        let dateFormatter = DateFormatter(dateFormatType: .yearMonthDayKR)
        let converted = dateFormatter.string(from: self)
        return converted
    }

    func fetchMonthDay() -> String {
        let dateFormatter = DateFormatter(dateFormatType: .monthDayKR)
        let converted = dateFormatter.string(from: self)
        return converted
    }
    
    func fetchYear() -> String {
        return String(Calendar.current.component(.year, from: self))
    }
    
    func fetchMonth() -> String {
        return String(Calendar.current.component(.month, from: self))
    }
    
    func fetchDay() -> String {
        return String(Calendar.current.component(.day, from: self))
    }
}

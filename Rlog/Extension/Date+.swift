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

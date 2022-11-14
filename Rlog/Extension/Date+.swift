//
//  Date+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation

extension Date {
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
    
    func fetchMonth() -> String {
        return String(Calendar.current.component(.month, from: date))
    }
}

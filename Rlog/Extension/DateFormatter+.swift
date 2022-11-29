//
//  DateFormatter+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation

extension DateFormatter {
    enum DateFormatType {
        case timeAndMinute
        case day
        case month
        case year
        case yearMonthDay
        case yearMonthDayKR
        case monthDayKR
        case weekday

        var dateFormat: String {
            switch self {
            case .timeAndMinute: return "HH:mm"
            case .day: return "dd"
            case .month: return "MM"
            case .year: return "yyyy"
            case .yearMonthDay: return "yyyy/MM/dd"
            case .yearMonthDayKR: return "yyyy년 MM월 dd일"
            case .monthDayKR: return "MM월 dd일"
            case .weekday: return "E"
            }
        }
    }

    convenience init(dateFormatType: DateFormatType) {
        self.init()
        self.dateFormat = dateFormatType.dateFormat
    }
}

//
//  DateFormatter+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation

extension DateFormatter {
//    static var calculateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter
//    }()

    enum DateFormatType {
        case timeAndMinute

        var dateFormat: String {
            switch self {
            case .timeAndMinute: return "HH:mm"
            }
        }
    }

    convenience init(dateFormatType: DateFormatType) {
        self.init()
        self.dateFormat = dateFormatType.dateFormat
    }
}

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

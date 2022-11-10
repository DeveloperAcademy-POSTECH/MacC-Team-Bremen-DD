//
//  WorkDayType.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/03.
//

import Foundation

enum WorkDayType: Int {
    case regular
    case reduce
    case overtime
    case extraDay

    var name: String {
        get {
            switch self {
            case .regular:
                return "정규"
            case .reduce:
                return "축소"
            case .overtime:
                return "연장"
            case .extraDay:
                return "추가"
            }
        }
    }
}

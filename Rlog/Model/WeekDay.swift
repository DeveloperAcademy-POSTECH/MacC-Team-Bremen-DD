//
//  WeekDay.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/24.
//

import Foundation

import Foundation

enum WeekDay: Int16 {
    case mon
    case tues
    case wed
    case thurs
    case fri
    case sat
    case sun

    var name: String {
        get {
            switch self {
            case .mon:
                return "월"
            case .tues:
                return "화"
            case .wed:
                return "수"
            case .thurs:
                return "목"
            case .fri:
                return "금"
            case .sat:
                return "토"
            case .sun:
                return "일"
            }
        }
    }
}

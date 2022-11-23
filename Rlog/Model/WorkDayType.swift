//
//  WorkDayType.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/03.
//

import SwiftUI

enum WorkDayType: Int, CaseIterable {
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

    var fullName: String {
        get {
            switch self {
            case .regular:
                return "정규근무"
            case .reduce:
                return "축소근무"
            case .overtime:
                return "연장근무"
            case .extraDay:
                return "추가근무"
            }
        }
    }

    var color: Color {
        get {
            switch self {
            case .regular:
                return Color.grayMedium
            case .reduce:
                return Color.pointRed
            case .overtime:
                return Color.pointBlue
            case .extraDay:
                return Color.pointPurple
            }
        }
    }
}

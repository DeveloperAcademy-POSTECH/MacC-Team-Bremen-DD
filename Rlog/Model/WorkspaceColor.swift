//
//  WorkspaceColor.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/20.
//

import SwiftUI

enum WorkspaceColor: String {
    case pointBlue
    case pointPink
    case pointPurple
    case pointRed
    case pointYellow

    var name: String {
        get {
            switch self {
            case .pointBlue:
                return "PointBlue"
            case .pointPink:
                return "PointPink"
            case .pointPurple:
                return "PointPurple"
            case .pointRed:
                return "PointRed"
            case .pointYellow:
                return "PointYellow"
            }
        }
    }

    var color: Color {
        get {
            switch self {
            case .pointBlue:
                return Color("PointBlue")
            case .pointPink:
                return Color("")
            case .pointPurple:
                return Color("PointPurple")
            case .pointRed:
                return Color("PointRed")
            case .pointYellow:
                return Color("PointYellow")
            }
        }
    }
}

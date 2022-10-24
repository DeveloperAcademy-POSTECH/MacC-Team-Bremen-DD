//
//  WorkspaceColor.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/20.
//

import SwiftUI

enum WorkspaceColor: String {
    case blue
    case pink
    case purple
    case red
    case yellow

    var name: String {
        get {
            switch self {
            case .blue:
                return "PointBlue"
            case .pink:
                return "PointPink"
            case .purple:
                return "PointPurple"
            case .red:
                return "PointRed"
            case .yellow:
                return "PointYellow"
            }
        }
    }

    var color: Color {
        get {
            switch self {
            case .blue:
                return Color("PointBlue")
            case .pink:
                return Color("PointPink")
            case .purple:
                return Color("PointPurple")
            case .red:
                return Color("PointRed")
            case .yellow:
                return Color("PointYellow")
            }
        }
    }
}

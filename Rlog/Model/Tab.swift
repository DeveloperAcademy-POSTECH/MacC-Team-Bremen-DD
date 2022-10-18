//
//  TabModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case schedule = "나의 알록"
    case workspace = "근무지 관리"
    case monthlyCalculte = "정산 현황"

    var title: String {
        rawValue
    }

    var systemName: String {
        switch self {
        case .schedule: return "square.and.pencil"
        case .workspace: return "list.bullet.rectangle.portrait.fill"
        case .monthlyCalculte: return "dollarsign.square.fill"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .schedule: ScheduleListView()
        case .workspace: WorkSpaceListView()
        case .monthlyCalculte: MonthlyCalculateListView()
        }
    }
}

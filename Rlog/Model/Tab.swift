//
//  TabModel.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/18.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case schedule = "일정"
    case workspace = "근무지"
    case monthlyCalculte = "정산"

    var title: String {
        rawValue
    }

    var systemName: String {
        switch self {
        case .schedule: return "calender.clock"
        case .workspace: return "suitcase"
        case .monthlyCalculte: return "coin"
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

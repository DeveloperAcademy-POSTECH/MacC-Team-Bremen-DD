//
//  WorkSpcaeList.swift
//  Rlog
//
//  Created by JungHoonPark on 2022/10/21.
//

import SwiftUI

struct WorkspaceCell: View {
    @ObservedObject private var viewModel: WorkspaceCellViewModel
    var workspace: WorkspaceEntity
    
    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        viewModel = WorkspaceCellViewModel(workspace: workspace)
    }
    
    var body: some View {
        NavigationLink {
            WorkspaceDetailView(workspace: viewModel.workspace)
        } label: {
            workspaceCell
        }
    }
}

private extension WorkspaceCell {
    var workspaceCell: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center){
                Rectangle()
                    .foregroundColor(Color.primary)
                    .frame(width: 4, height: 16)
                Text(workspace.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.fontBlack)
            }
            .padding(.bottom, 16)
            
            VStack(spacing: 8){
                workspaceRowInfo
                workspaceScheduleInfo
            }
        }
        .padding()
        .background(Color.backgroundCard)
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.backgroundStroke, lineWidth: 2)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
    }
    
    var workspaceRowInfo: some View {
        ForEach(WorkTitleType.allCases, id: \.self) { workTitle in
            HStack(spacing: 0) {
                Text(workTitle.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.grayMedium)
                Spacer()
                Text(workTitle.workInfo(of: workspace))
                    .font(.subheadline)
                    .foregroundColor(.fontBlack)
            }
        }
    }
    
    var workspaceScheduleInfo: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("?????? ??????")
                .font(.subheadline)
                .foregroundColor(.grayMedium)
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(viewModel.schedules, id: \.self) { schedule in
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(schedule.repeatDays, id: \.self) { week in
                                Text(week)
                                    .font(.subheadline)
                                    .foregroundColor(.fontBlack)
                                    .padding(.horizontal, 1)
                            }
                        }
                        .padding(.trailing, 3)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Group {
                                Text("\(schedule.startHour):\(schedule.startMinute < 30 ? "00" : "30") - ")
                                Text("\(schedule.endHour):\(schedule.endMinute < 30 ? "00" : "30")")
                            }
                            .font(.subheadline)
                            .foregroundColor(.fontBlack)
                            
                            if schedule.startHour >= schedule.endHour {
                                Text("+1")
                                    .font(.caption)
                                    .foregroundColor(Color.grayMedium)
                                    .padding(.leading, 2)
                            }
                        }
                    }
                }
            }
        }
    }
}

// ????????? ?????? ????????????.
fileprivate enum WorkTitleType: String, CaseIterable {
    case hourlyWage = "??????"
    case payday = "?????????"
    case juhyu = "????????????"
    case tax = "?????????"
    
    func workInfo(of workspace: WorkspaceEntity) -> String {
        switch self {
        case .hourlyWage: return "\(String(workspace.hourlyWage)) ???"
        case .payday: return "?????? \(String(workspace.payDay)) ???"
        case .juhyu: return workspace.hasJuhyu ? "??????" : "?????????"
        case .tax: return workspace.hasTax ? "??????" : "?????????"
        }
    }
}

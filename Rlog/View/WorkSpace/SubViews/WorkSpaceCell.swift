//
//  WorkSpcaeList.swift
//  Rlog
//
//  Created by JungHoonPark on 2022/10/21.
//

import SwiftUI

struct WorkSpaceCell: View {
    @ObservedObject private var viewModel: WorkSpaceCellViewModel
    
    var workspace: WorkspaceEntity
    
    init(workspace: WorkspaceEntity) {
        self.workspace = workspace
        viewModel = WorkSpaceCellViewModel(workspace: workspace)
    }
    
    var body: some View {
        NavigationLink {
            WorkSpaceDetailView(workspace: viewModel.workspace)
        } label: {
            makeWorkSpaceCardContent(workspace: workspace)
        }
    }
}

private extension WorkSpaceCell {
    func makeWorkSpaceRowInfo(workTitle: String, workInfo: String) -> some View {
        HStack() {
            Text(workTitle)
                .font(.subheadline)
                .foregroundColor(.grayMedium)
            Spacer()
            Text(workInfo)
                .font(.subheadline)
                .foregroundColor(.fontBlack)
        }
    }
    
    func makeWorkSpaceScheduleInfo(workTitle: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(workTitle)
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
                        
                        Text("\(schedule.startHour):\(schedule.startMinute)0 - \(schedule.endHour):\(schedule.endMinute)0")
                            .font(.subheadline)
                            .foregroundColor(.fontBlack)
                    }
                }
            }
        }
    }
    
    func makeWorkSpaceCardContent(workspace: WorkspaceEntity) -> some View {
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
                makeWorkSpaceRowInfo(workTitle: "시급", workInfo: "\(String(workspace.hourlyWage)) 원")
                makeWorkSpaceRowInfo(workTitle: "급여일", workInfo: "매월 \(String(workspace.payDay)) 일")
                makeWorkSpaceRowInfo(workTitle: "주휴수당", workInfo: workspace.hasJuhyu ? "적용" : "미적용")
                makeWorkSpaceRowInfo(workTitle: "소득세", workInfo: workspace.hasTax ? "적용" : "미적용")
                makeWorkSpaceScheduleInfo(workTitle: "근무유형")
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
}


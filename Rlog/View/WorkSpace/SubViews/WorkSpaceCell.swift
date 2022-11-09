//
//  WorkSpcaeList.swift
//  Rlog
//
//  Created by JungHoonPark on 2022/10/21.
//

import SwiftUI

struct WorkSpaceCell: View {
    @ObservedObject var viewModel: WorkSpaceCellViewModel

    init(workspace: WorkspaceEntity) {
        self.viewModel = WorkSpaceCellViewModel(workspace: workspace)
    }
    
    var body: some View {
        NavigationLink {
            WorkSpaceDetailView(workspace: viewModel.workspace, schedules: viewModel.schedules)
        } label: {
            makeWorkSpaceCardContent(workspace: viewModel.workspace, schedules: viewModel.schedules)
        }
    }
}

private extension WorkSpaceCell {
    func makeWorkSpaceRowInfo(workTitle: String, workInfo: String) -> some View {
        HStack() {
            Text(workTitle)
                .font(.subheadline)
                .foregroundColor(.grayLight)
            Spacer()
            Text(workInfo)
                .font(.subheadline)
                .foregroundColor(.fontBlack)
        }
    }

    func makeWorkSpaceScheduleInfo(workTitle: String, schedules: [ScheduleEntity]) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(workTitle)
                .font(.subheadline)
                .foregroundColor(.grayLight)
            Spacer()
            VStack(spacing: 0) {
                ForEach(schedules) { schedule in
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(schedule.repeatedSchedule, id:\.self) { week in
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
    
    func makeWorkSpaceCardContent(workspace: WorkspaceEntity, schedules: [ScheduleEntity]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center){
                Rectangle()
                    .foregroundColor(Color(workspace.colorString))
                    .frame(width: 3, height: 17)
                Text(workspace.name)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.fontBlack)
            }
            .padding(.bottom, 20)

            VStack(spacing: 8){
                makeWorkSpaceRowInfo(workTitle: "시급", workInfo: "\(String(workspace.hourlyWage)) 원")
                makeWorkSpaceRowInfo(workTitle: "급여일", workInfo: "매월 \(String(workspace.paymentDay)) 일")
                makeWorkSpaceRowInfo(workTitle: "주휴수당", workInfo: workspace.hasJuhyu ? "적용" : "미적용")
                makeWorkSpaceRowInfo(workTitle: "소득세", workInfo: workspace.hasTax ? "적용" : "미적용")
                makeWorkSpaceScheduleInfo(workTitle: "근무유형", schedules: schedules)
            }
        }
        .padding()
        .padding([.horizontal, .bottom])
    }
}




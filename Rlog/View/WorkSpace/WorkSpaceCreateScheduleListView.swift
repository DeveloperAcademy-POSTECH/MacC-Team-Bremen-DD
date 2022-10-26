//
//  WorkSpaceCreateScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

import SwiftUI

struct WorkSpaceCreateScheduleListView: View {
    @ObservedObject var viewModel: WorkSpaceCreateScheduleListViewModel
    init(isActive: Binding<Bool>, workspaceModel: WorkSpaceModel) {
        self.viewModel = WorkSpaceCreateScheduleListViewModel(isActive: isActive, workspaceModel: workspaceModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleSubView(title: "근무 일정을 입력해주세요.")
            labelText
            VStack(spacing: 16) {
                ForEach(viewModel.scheduleList, id: \.self) { schedule in
                    ScheduleContainer(
                        repeatedSchedule: schedule.repeatedSchedule,
                        startHour: schedule.startHour,
                        startMinute: schedule.startMinute,
                        endHour: schedule.endHour,
                        endMinute: schedule.endMinute
                    )
                }
                addScheduleButton
            }
            Spacer()
            
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarNextButton
            }
        }
        .sheet(isPresented: $viewModel.isShowingModal) {
            WorkSpaceCreateCreatingScheduleView(isShowingModal: $viewModel.isShowingModal, scheduleList: $viewModel.scheduleList)
        }
    }
}

private extension WorkSpaceCreateScheduleListView {
    @ViewBuilder
    /*
    func createScheduleListCell(for item: ScheduleModel) -> some View {
        HStack(spacing: 0) {
            ForEach(item.repeatedSchedule,id: \.self) { day in
                Text("\(day) ")
            }
            Spacer()
            Text("\(item.startHour):\(item.startMinute) - \(item.endHour):\(item.endMinute)")
        }
        .padding()
        .background(Color(red: 0.962, green: 0.962, blue: 0.962))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    */
    var toolbarNextButton: some View {
        NavigationLink(destination:  WorkSpaceCreateConfirmationView(isActive: $viewModel.isActive, workspaceData: viewModel.workspaceModel, scheduleData: viewModel.scheduleList)) {
                Text("다음")
                    .foregroundColor(viewModel.isDisabledNextButton ? Color(red: 0.82, green: 0.82, blue: 0.839) : .fontBlack)
            }
            .disabled(viewModel.isDisabledNextButton)
    }
    var labelText: some View {
        Text("근무 유형")
            .font(.caption)
            .foregroundColor(.fontLightGray)
    }
    var addScheduleButton: some View {
        StrokeButton(label: "+ 근무 일정 추가하기", buttonType: .add) {
            viewModel.didTapAddScheduleButton()
        }
    }
}

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
            TitleSubView(title: "근무 패턴을 입력해주세요.")
            labelText
            VStack(spacing: 16) {
                ForEach(0..<viewModel.scheduleList.count, id: \.self) { Idx in
                    
                    deletableSchedulePattern(scheduleIdx: Idx)
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
    var toolbarNextButton: some View {
        NavigationLink(destination:  WorkSpaceCreateConfirmationView(
            isActive: $viewModel.isActive,
            workspaceData: viewModel.workspaceModel,
            scheduleData: viewModel.scheduleList)
        ) {
            Text("다음")
                .foregroundColor(viewModel.isDisabledNextButton ? Color(red: 0.82, green: 0.82, blue: 0.839) : .fontBlack)
        }
        .disabled(viewModel.isDisabledNextButton)
    }
    
    var labelText: some View {
        Text("근무패턴")
            .font(.caption)
            .foregroundColor(.grayLight)
    }
    
    var addScheduleButton: some View {
        StrokeButton(label: "+ 근무패턴 추가", buttonType: .add) {
            viewModel.didTapAddScheduleButton()
        }
    }
    
    @ViewBuilder
    func deletableSchedulePattern(scheduleIdx: Int) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .foregroundColor(.gray)
            .overlay {
                HStack {
                    HStack {
                        ForEach(viewModel.scheduleList[scheduleIdx].repeatedSchedule, id: \.self) { day in
                            Text(day)
                        }
                    }
                    Spacer()
                    HStack {
                        if viewModel.scheduleList[scheduleIdx].startMinute.count == 1 {
                            Text("\(viewModel.scheduleList[scheduleIdx].startHour):0\(viewModel.scheduleList[scheduleIdx].startMinute)")
                        } else {
                            Text("\(viewModel.scheduleList[scheduleIdx].startHour):\(viewModel.scheduleList[scheduleIdx].startMinute)")
                        }
                        
                        Text("-")
                        
                        if viewModel.scheduleList[scheduleIdx].endMinute.count == 1 {
                            Text("\(viewModel.scheduleList[scheduleIdx].endHour):0\(viewModel.scheduleList[scheduleIdx].endMinute)")
                        } else {
                            Text("\(viewModel.scheduleList[scheduleIdx].endHour):\(viewModel.scheduleList[scheduleIdx].endMinute)")
                        }
                    }
                    Button {
                        viewModel.didTapDeleteButton(idx: scheduleIdx)
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
    }
}

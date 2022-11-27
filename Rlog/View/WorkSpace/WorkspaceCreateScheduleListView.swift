//
//  WorkSpaceCreateScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

import SwiftUI

struct WorkspaceCreateScheduleListView: View {
    @ObservedObject var viewModel: WorkspaceCreateScheduleListViewModel
    @Environment(\.dismiss) var dismiss
    init(isActiveNavigation: Binding<Bool>, workspaceModel: WorkSpaceModel) {
        self.viewModel = WorkspaceCreateScheduleListViewModel(isActiveNavigation: isActiveNavigation, workspaceModel: workspaceModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TitleSubView(title: "근무 패턴을 입력해주세요.")
            VStack(alignment: .leading, spacing: 8) {
                labelText
                VStack(spacing: 16) {
                    ForEach(0..<viewModel.scheduleList.count, id: \.self) { Idx in
                        createDeletableSchedulePatternView(tappedScheduleID: Idx)
                    }
                    addScheduleButton
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitle("근무패턴 등록")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarNextButton
            }
        }
        .sheet(isPresented: $viewModel.isShowingModal) {
            WorkspaceCreateCreatingScheduleView(
            isShowingModal: $viewModel.isShowingModal, 
            scheduleList: $viewModel.scheduleList
            )
        }
    }
}

private extension WorkspaceCreateScheduleListView {    
    var toolbarNextButton: some View {
        NavigationLink(destination:  WorkspaceCreateConfirmationView(
            isActiveNavigation: $viewModel.isActiveNavigation,
            workspaceData: viewModel.workspaceModel,
            scheduleData: viewModel.scheduleList)
        ) {
            Text("다음")
                .foregroundColor(viewModel.isDisabledNextButton ? .grayLight : .primary)
        }
        .disabled(viewModel.isDisabledNextButton)
    }
    
    var labelText: some View {
        Text("근무패턴")
            .font(.caption)
            .foregroundColor(.grayMedium)
    }
    
    var addScheduleButton: some View {
        StrokeButton(label: "+ 근무패턴 추가", buttonType: .add) {
            viewModel.didTapAddScheduleButton()
        }
    }
    
    @ViewBuilder
    func createDeletableSchedulePatternView(tappedScheduleID: Int) -> some View {
        let tappedSchedule = viewModel.scheduleList[tappedScheduleID]
        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .foregroundColor(.gray)
            .overlay {
                //TODO: 컴포넌트화 예정입니다.
                HStack {
                    HStack {
                        ForEach(tappedSchedule.repeatedSchedule, id: \.self) { day in
                            Text(day)
                        }
                    }
                    Spacer()
                    HStack(spacing : 0) {
                        Text(tappedSchedule.startMinute < 30 ? "\(tappedSchedule.startHour):0\(tappedSchedule.startMinute)" : "\(tappedSchedule.startHour):\(tappedSchedule.startMinute)")
                        Text(" - ")
                        Text(tappedSchedule.endMinute < 30 ? "\(tappedSchedule.endHour):0\(tappedSchedule.endMinute)" : "\(tappedSchedule.endHour):\(tappedSchedule.endMinute)")
                    }
                    Button {
                        viewModel.didTapDeleteButton(idx: tappedScheduleID)
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
    }
}

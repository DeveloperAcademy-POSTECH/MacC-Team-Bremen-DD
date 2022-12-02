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
                    schedulePatternList
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
    var schedulePatternList: some View {
        
        ForEach(0..<viewModel.scheduleList.count, id: \.self) { Idx in
            ScheduleContainer(
                repeatedSchedule: viewModel.scheduleList[Idx].repeatedSchedule,
                startHour: Int16(viewModel.scheduleList[Idx].startHour),
                startMinute: Int16(viewModel.scheduleList[Idx].startMinute),
                endHour: Int16(viewModel.scheduleList[Idx].endHour),
                endMinute: Int16(viewModel.scheduleList[Idx].endMinute)
            ) {
                viewModel.didTapDeleteButton(idx: Idx)
            }
        }
    }
}

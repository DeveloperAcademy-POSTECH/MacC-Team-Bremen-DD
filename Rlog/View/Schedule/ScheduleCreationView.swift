//
//  ScheduleCreationView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

struct ScheduleCreationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ScheduleCreationViewModel
    @State private var isCreationButtonTapped = false
    
    init(of selectedDate: Date, hasDoneWorkdays: [WorkdayEntity], hasNotDoneWorkdays: [WorkdayEntity]) {
        self.viewModel = ScheduleCreationViewModel(of: selectedDate, hasDoneWorkdays: hasDoneWorkdays, hasNotDoneWorkdays: hasNotDoneWorkdays)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                workspace
                workdate
                components
                memo
                Spacer()
            }
            .padding()
        }
        .onAppear { viewModel.onAppear() }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                creationButton
            }
        }
    }
}

private extension ScheduleCreationView {
    var workspace: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("근무지")
                .font(.caption)
                .foregroundColor(.grayMedium)
            WorkspaceListPicker(
                selection: $viewModel.selectedWorkspaceString,
                workspaceList: viewModel.getWorkspacesListString()
            )
        }
    }
    
    var workdate: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("근무 날짜")
                .font(.caption)
                .foregroundColor(.grayMedium)
            BorderedPicker(
                date: $viewModel.workday,
                isActive: $viewModel.isWorkdayPickerActive,
                type: .date
            )
        }
    }
    
    var components: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("근무 시간")
                .font(.caption)
                .foregroundColor(.grayMedium)
            BorderedPicker(
                date: $viewModel.startTime,
                isActive: $viewModel.isStartTimePickerActive,
                type: .startTime
            )
            BorderedPicker(
                date: $viewModel.endTime,
                isActive: $viewModel.isEndTimePickerActive,
                type: .endTime
            )
        }
    }
    
    var memo: some View {
        InputFormElement(
            containerType: .none(title: "메모 (선택사항)"),
            text: $viewModel.memo
        )
    }
    
    var creationButton: some View {
        Button {
            viewModel.didTapCreationButton()
        } label: {
            Text("완료")
                .foregroundColor(viewModel.isSelectedWorkspace ? Color.primary : Color.grayLight)
        }
        .disabled(!viewModel.isSelectedWorkspace)
        .alert("근무 추가", isPresented: $viewModel.isAlertActive) {
            Button("취소", role: .cancel) { viewModel.isAlertActive = false }
            Button("추가", role: .none) {
                viewModel.didTapConfirmationButton()
                dismiss()
            }
        } message: {
            Text("근무를 추가합니다")
        }
        .alert("근무가 중복됩니다.", isPresented: $viewModel.isConflictAlertActive) {
            Button("확인", role: .cancel) { viewModel.isConflictAlertActive = false }
        }
    }
}

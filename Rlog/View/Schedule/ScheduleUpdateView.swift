//
//  ScheduleUpdateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/11/18.
//

import SwiftUI

struct ScheduleUpdateView: View {
    @ObservedObject var viewModel: ScheduleUpdateViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(workday: WorkdayEntity) {
        viewModel = ScheduleUpdateViewModel(workday: workday)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                workspace
                workdate
                components
                memo
                HDivider()
                deleteButton
                Spacer()
            }
            .padding()
        }
        .navigationTitle("근무 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarConfirmButton
            }
        }

    }
}

private extension ScheduleUpdateView {
    var toolbarConfirmButton: some View {
        Button {
            Task {
                await viewModel.didTapConfirmationButton()
                dismiss()
            }
        } label: {
            Text("완료")
                .foregroundColor(.primary)
        }
    }
    
    var workspace: some View {
        InputFormElement(
            containerType: .none(title: "근무지"),
            text: $viewModel.name
        )
        .disabled(true)
    }
    
    var workdate: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("근무 날짜")
                .font(.caption)
                .foregroundColor(.grayMedium)
            BorderedPicker(
                date: $viewModel.date,
                isActive: $viewModel.isWorkdayPickerActive,
                type: .date
            )
        }
        .disabled(true)
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
    
    var deleteButton: some View {
        StrokeButton(label: "근무 삭제", buttonType: .destructive) {
            viewModel.didTapDeleteButton()
        }
        .padding(.top, -8)
        .alert("근무 삭제", isPresented: $viewModel.isAlertActive) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                Task {
                    await viewModel.didConfirmDeleteWorday()
                    dismiss()
                }
            }
        } message: {
            Text("해당 근무를 삭제합니다.")
        }
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.backward")
                Text("이전")
            }
            .foregroundColor(Color.fontBlack)
        })
    }
}

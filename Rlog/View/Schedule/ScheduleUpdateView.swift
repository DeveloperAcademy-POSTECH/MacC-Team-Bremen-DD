//
//  ScheduleUpdateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/11/18.
//

import SwiftUI

struct ScheduleUpdateView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ScheduleUpdateViewModel()
    let workday: WorkdayEntity
    
    var body: some View {
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
        .onAppear { viewModel.onAppear(workday) }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarConfirmButton
            }
        }

    }
}

private extension ScheduleUpdateView {
    var toolbarConfirmButton: some View {
        Button{
            viewModel.didTapConfirmationButton()
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
                type: .startTime
            )
            BorderedPicker(
                date: $viewModel.endTime,
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
        .alert("근무 삭제", isPresented: $viewModel.isAlertActive) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                viewModel.didConfirmDeleteWorday()
                dismiss()
            }
        } message: {
            Text("해당 근무를 삭제합니다.")
        }
        .padding(.top, -8)
    }
}

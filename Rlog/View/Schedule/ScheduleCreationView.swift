//
//  ScheduleCreationView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

struct ScheduleCreationView: View {
    @ObservedObject var viewModel = ScheduleCreationViewModel()
    @State private var isCreationButtonTapped = false
    var workspaceListSting: [String] {
        return viewModel.getWorkspacesListString()
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
            ToolbarItem(placement: .navigationBarTrailing) {
                creationButton
            }
        }
    }
}

private extension ScheduleCreationView {
    var workspace: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("근무 날짜")
                .font(.caption)
                .foregroundColor(.grayMedium)
            WorkspaceListPicker(
                selection: $viewModel.selectedWorkspaceString,
                workspaceList: workspaceListSting
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
    
    var creationButton: some View {
        Button {
            viewModel.didTapCreationButton()
        } label: {
            Text("완료")
        }
    }
}

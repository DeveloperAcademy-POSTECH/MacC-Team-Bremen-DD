//
//  ScheduleCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleCreateView: View {
    @ObservedObject private var viewModel = ScheduleCreateViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                workspace
                    .padding(.top, 40)
                workDate
                schedule
                reasonInput
                Spacer()
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("일정 추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Text("취소")
                        .foregroundColor(Color.fontLightGray)
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if !viewModel.hasFilled {
                        Task {
                            await viewModel.didTapConfirmButton()
                            DispatchQueue.main.async {
                                dismiss()
                            }
                        }
                    }
                }, label: {
                    Text("완료")
                        .foregroundColor(viewModel.confirmButtonForegroundColor)
                })
            }
        }
    }
}

private extension ScheduleCreateView {
    var workspace: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무지")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(viewModel.workspaces, id: \.self) { workspace in
                            Button(action: {
                                viewModel.selectedWorkspace = workspace
                            }, label: {
                                Text(workspace.name)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 3)
                                    .foregroundColor(viewModel.fetchWorkspaceButtonFontColor(compare: workspace))
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(viewModel.fetchWorkspaceButtonBackground(compare: workspace))
                                    )
                            })
                        }
                    }
                }
                .frame(height: 23)
                .padding(.leading, 5)
                .padding(.bottom, 9)
                HDivider()
            }
            .padding(.top, 8)
        }
    }
    
    var workDate: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무 날짜")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    viewModel.isHideDatePicker.toggle()
                }, label: {
                    Text("\(Calendar.current.component(.year, from: viewModel.workDate))년 \(Calendar.current.component(.month, from: viewModel.workDate))월 \(Calendar.current.component(.day, from: viewModel.workDate))일")
                        .foregroundColor(.fontLightGray)
                        .padding(.vertical, 9)
                })
                if viewModel.isHideDatePicker {
                    DatePicker("", selection: $viewModel.workDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                }
                HDivider()
            }
            .padding(.top, 8)
        }
    }
    
    var schedule: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무 시간")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            HStack(spacing: 0) {
                UnderlinedTextField(textFieldType: .time, text: $viewModel.startHourText)
                Text(":")
                UnderlinedTextField(textFieldType: .time, text: $viewModel.startMinuteText)
                Text("-")
                    .padding(.horizontal, 10)
                UnderlinedTextField(textFieldType: .time, text: $viewModel.endHourText)
                Text(":")
                UnderlinedTextField(textFieldType: .time, text: $viewModel.endMinuteText)
            }
            .padding(.top, 9)
        }
    }
    
    var reasonInput: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("사유")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            UnderlinedTextField(textFieldType: .reason, text: $viewModel.reason)
                .padding(.top, 25)
        }
    }
}

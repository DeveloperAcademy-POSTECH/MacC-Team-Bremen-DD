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
        VStack(alignment: .leading, spacing: 0) {
            workspace
                .padding(.top, 40)
            workDate
                .padding(.top)
            schedule
                .padding(.top)
            reasonInput
                .padding(.top)
            Spacer()
        }
        .padding(.horizontal)
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
                            dismiss()
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
                // TODO: - 컴포넌트 Divider 넣기
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
                // TODO: - 컴포넌트 Divider 넣기
            }
            .padding(.top, 8)
        }
    }
    
    var schedule: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무 시간")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            // TODO: - TextField 컴포넌트로 변경
            HStack(spacing: 0) {
                TextField("00", text: $viewModel.startHourText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Text(":")
                TextField("00", text: $viewModel.startMinuteText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Text("-")
                    .padding(.horizontal, 10)
                TextField("00", text: $viewModel.endHourText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Text(":")
                TextField("00", text: $viewModel.endMinuteText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    var reasonInput: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("사유")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            // TODO: - 컴포넌트 텍스트필드로 변경
            TextField("사유를 입력해주세요.", text: $viewModel.reason)
                .frame(height: 40)
                .padding(.top)
        }
    }
}

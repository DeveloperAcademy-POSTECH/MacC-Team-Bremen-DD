//
//  ScheduleUpdateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleUpdateView: View {
    @ObservedObject private var viewModel: ScheduleUpdateViewModel
    @Environment(\.dismiss) var dismiss
    
    init(workDayEntity: WorkDayEntity) {
        self.viewModel = ScheduleUpdateViewModel(workDayEntity: workDayEntity)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            workspace
                .padding(.top, 40)
            workDate
            startTime
            endTime
            reasonInput
            deleteButton
                .padding(.top, 16)
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("일정 수정하기")
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
                    Task {
                        await viewModel.didTapConfirmButton()
                        DispatchQueue.main.async {
                            dismiss()
                        }
                    }
                }, label: {
                    Text("완료")
                        .foregroundColor(Color.primary)
                })
            }
        }
    }
}

private extension ScheduleUpdateView {
    var workspace: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무지")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.workDayEntity.workspace.name)
                    .foregroundColor(Color.fontLightGray)
                    .padding(.horizontal)
                    .padding(.vertical, 9)
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
                Text("\(viewModel.workDay.yearInt)년 \(viewModel.workDay.monthInt)월 \(viewModel.workDay.dayInt)일")
                    .foregroundColor(Color.fontLightGray)
                    .padding(.horizontal)
                    .padding(.vertical, 9)
                HDivider()
            }
            .padding(.top, 8)
        }
    }
    
    var startTime: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("출근 시간")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            TimeEditer(time: $viewModel.startTime, isTimeChanged: $viewModel.isStartTimeChanaged)
                .padding(.top, 8)
        }
    }
    
    var endTime: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("퇴근 시간")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            TimeEditer(time: $viewModel.endTime, isTimeChanged: $viewModel.isEndTimeChanaged)
                .padding(.top, 8)
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
    
    var deleteButton: some View {
        StrokeButton(label: "일정 삭제하기", buttonType: .destructive) {
            Task {
                await viewModel.didTapDeleteButton()
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        }
    }
    
    private struct TimeEditer: View {
        @ObservedObject var viewModel: TimeEditorViewModel
        
        init(time: Binding<String>, isTimeChanged: Binding<Bool>) {
            self.viewModel = TimeEditorViewModel(time: time, isTimeChanged: isTimeChanged)
        }
        
        var body: some View {
            HStack(spacing: 0) {
                Text(viewModel.time)
                    .font(.title3)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundColor(viewModel.fontColor)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.backgroundColor)
                    )
                    .padding(.trailing, 22)
                HStack(spacing: 8) {
                    ForEach(TimeUnit.allCases, id: \.self) { unit in
                        Button(unit.rawValue) {
                            viewModel.didTapTimePresetButton(unit: unit)
                        }
                        .buttonStyle(TimeEditButtonStyle())
                    }
                }
            }
        }
    }
    
    private struct TimeEditButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? Color(UIColor.systemGray4) : Color(UIColor.systemGray6))
                    .frame(height: 23)
                configuration.label
                    .font(.footnote)
                    .foregroundColor(configuration.isPressed ? .white : Color.fontLightGray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
            }
        }
    }
}

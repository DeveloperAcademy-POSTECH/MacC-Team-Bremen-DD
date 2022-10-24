//
//  ScheduleCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleCreateView: View {
    @ObservedObject var viewModel = ScheduleCreateViewModel()
    
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
            deleteButton
                .padding(.top, 32)
            Spacer()
        }
        .padding(.horizontal)
    }
}

extension ScheduleCreateView {
    var workspace: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무지")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 리스트 뷰에서 근무지명 받아오기
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(viewModel.workspaces.indices, id: \.self) { index in
                            WorkSpaceToggleItem(flagOptions: $viewModel.workspaceFlags, tag: index, label: viewModel.workspaces[index])
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
                // TODO: - 리스트 뷰에서 날짜 받아오기
                Text("2022년 10월 8일")
                    .foregroundColor(Color.fontLightGray)
                    .padding(.horizontal)
                    .padding(.vertical, 9)
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
    
    // TODO: - 컴포넌트 버튼으로 변경
    var deleteButton: some View {
        Button(action: {}, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red)
                    .frame(height: 54)
                Text("일정 삭제하기")
                    .foregroundColor(Color.red)
            }
        })
    }
    
    private struct WorkSpaceToggleItem: View {
        @Binding var flagOptions: [Bool]
        var tag: Int
        var label: String
        
        var body: some View {
            let isOn = Binding ( get: { flagOptions[tag] }, set: { value in
                flagOptions = flagOptions.enumerated().map { $0.0 == self.tag }
            })
            return Toggle(label, isOn: isOn).toggleStyle(WorkSpaceToggleStyle(label: label))
        }
    }
    
    private struct WorkSpaceToggleStyle: ToggleStyle {
        var label: String
        
        func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 10, height: 23)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(configuration.isOn ? .white : Color.fontLightGray)
                Spacer()
                    .frame(width: 10, height: 23)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isOn ? Color.primary : Color(UIColor.systemGray6))
                    .frame(height: 24)
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

//
//  ScheduleCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleCreateView: View {
    @ObservedObject var viewModel = ScheduleCreateViewModel()
    @State var reason = ""
    
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
                HStack(spacing: 8) {
                    ForEach(viewModel.workspaces, id: \.self) { workspace in
                        Button(workspace) {
                            // TODO: - ViewModel에서 로직 구현
                        }
                    }
                }
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
                    .keyboardType(.namePhonePad)
                Text(":")
                TextField("00", text: $viewModel.startMinuteText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.namePhonePad)
                Text("-")
                    .padding(.horizontal, 10)
                TextField("00", text: $viewModel.endHourText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.namePhonePad)
                TextField("00", text: $viewModel.endMinuteText)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.namePhonePad)
            }
        }
    }
    
    var reasonInput: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("사유")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            // TODO: - 컴포넌트 텍스트필드로 변경
            TextField("사유를 입력해주세요.", text: $reason)
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
}

struct ScheduleCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCreateView()
    }
}

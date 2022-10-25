//
//  ScheduleUpdateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleUpdateView: View {
    @ObservedObject var viewModel = ScheduleUpdateViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                Button(action: {}, label: {
                    Text("완료")
                        .foregroundColor(Color.primary)
                })
            }
        }
    }
}

extension ScheduleUpdateView {
    var workspace: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("근무지")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 리스트 뷰에서 근무지명 받아오기
                Text("제이든의 낚시 교실")
                    .foregroundColor(Color.fontLightGray)
                    .padding(.horizontal)
                    .padding(.vertical, 9)
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
    
    var startTime: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("출근 시간")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            TimeEditer()
                .padding(.top, 8)
        }
    }
    
    var endTime: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("퇴근 시간")
                .font(.subheadline)
                .foregroundColor(Color.fontLightGray)
            
            TimeEditer()
                .padding(.top, 8)
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
    
    private struct TimeEditer: View {
        var body: some View {
            HStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        // TODO: - 컬러 변경
                        .fill(Color.gray)
                        .frame(width: 76, height: 32)
                    Text("11 : 30")
                        .font(.title3)
                        .foregroundColor(.fontBlack)
                }
                .padding(.trailing, 22)
                HStack(spacing: 8) {
                    ForEach(TimeUnit.allCases, id: \.self) { unit in
                        Button(unit.rawValue) {
                            // TODO: - ViewModel Action 구현
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

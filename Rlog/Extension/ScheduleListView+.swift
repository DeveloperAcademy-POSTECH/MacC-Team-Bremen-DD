//
//  ScheduleListView+.swift
//  Rlog
//
//  Created by 정지혁 on 2022/10/20.
//

import SwiftUI

extension ScheduleListView {
    struct StatusPicker: View {
        @ObservedObject private var viewModel: StatusPickerViewModel
        
        init(selectedScheduleCase: Binding<ScheduleCase>) {
            self.viewModel = StatusPickerViewModel(selectedScheduleCase: selectedScheduleCase)
        }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 97)
                        .cornerRadius(20)
                        .offset(x: viewModel.statusPickerOffset)
                    HStack(spacing: 0) {
                        ForEach(viewModel.scheduleCases, id: \.self) { schedule in
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 176 / 2)
                                Text(schedule.rawValue)
                                    .font(.caption2)
                                    .fontWeight(viewModel.getStatusPickerTextWeight(compareCase: schedule))
                                    .foregroundColor(viewModel.getStatusPickerForegroundColor(compareCase: schedule))
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.selectedScheduleCase = schedule
                                        }
                                    }
                            }
                        }
                    }
                }
                .cornerRadius(20)
            }
        }
    }
    
    // TODO: - 근무지 모델 만들어서, ScheduleCell view model을 만들고, 거기서 값을 가져오는 방법을 사용할 예정
    struct ScheduleCell: View {
        var body: some View {
            ZStack {
                // TODO: - 조건에 따른 색깔 처리(ViewModel 예정)
                createBackgroundRectangle(workspaceColor: "PointRed", isShow: true)
                VStack {
                    createCellHeader(workspaceColor: "PointRed", workspaceName: "제이든의 낚시교실", spendHour: 4)
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0) {
                        // TODO: - 시작 시간, 끝난 시간 처리
                        createCellContent(monthInt: 10, dayInt: 8, startTime: "17", endTime: "21")
                        Spacer()
                        createCellButton(workspaceColor: "PointRed", isShow: true)
                    }
                    .padding(.bottom, -5)
                    .padding(.leading, 14)
                }
                .padding(20)
            }
        }
        
        func createBackgroundRectangle(workspaceColor: String, isShow: Bool) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    // TODO: - view model에서 처리
                    .fill(isShow ? Color(workspaceColor) : .white)
                    .frame(height: 97)
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color.white)
                    .padding(1)
            }
        }
        
        func createCellHeader(workspaceColor: String, workspaceName: String, spendHour: Int) -> some View {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color(workspaceColor))
                    .frame(width: 3, height: 17)
                // TODO: - 근무지명 받아오기
                Text(workspaceName)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                    .padding(.leading, 3)
                Spacer()
                // TODO: - 근무 시간 받아오기
                Text("\(spendHour)시간")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
        }
        
        func createCellContent(monthInt: Int, dayInt: Int, startTime: String, endTime: String) -> some View {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 요일 처리
                Text("\(monthInt)월 \(dayInt)일 금요일")
                    .font(.caption)
                    .foregroundColor(Color.fontBlack)
                // TODO: - 시간 처리
                Text("\(startTime)시 00분 ~ \(endTime)시 00분")
                    .font(.caption2)
                    .foregroundColor(Color.fontLightGray)
            }
        }
        
        func createCellButton(workspaceColor: String, isShow: Bool) -> some View {
            HStack(spacing: 11) {
                Button(action: {
                    // TODO: - 모달 구현
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 11)
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 41, height: 22)
                        Text("수정")
                            .font(.footnote)
                            .foregroundColor(Color.fontBlack)
                    }
                })
                if isShow {
                    Button(action: {
                        // TODO: - ViewModel에서 확인 로직 구현
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 11)
                            // TODO: - workspace에 맞는 컬러 수정
                                .fill(Color(workspaceColor))
                                .frame(width: 41, height: 22)
                            Text("확인")
                                .font(.footnote)
                                .foregroundColor(Color.white)
                        }
                    })
                }
            }
        }
    }
}

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
    
    struct ScheduleCell: View {
        // TODO: - 근무지 모델 만들어서, ScheduleCell view model을 만들고, 거기서 값을 가져오는 방법을 사용할 예정
        var isShow = true
        
        var body: some View {
            // TODO: - 조건에 따른 색깔 처리(ViewModel 예정)
            VStack(spacing: 0) {
                cellHeader
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    // TODO: - 시작 시간, 끝난 시간 처리
                    cellContent
                    Spacer()
                    cellButton
                }
                .padding(EdgeInsets(top: 0, leading: 14, bottom: -2, trailing: 0))
            }
            .padding()
            .frame(height: 97)
            .background(
                backgroundRectangle
            )
        }
        
        var backgroundRectangle: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    // TODO: - view model에서 처리
                    .fill(isShow ? Color("PointRed") : .white)
                    .frame(height: 97)
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color.white)
                    .padding(1)
            }
        }
        
        var cellHeader: some View {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color("PointRed"))
                    .frame(width: 3, height: 17)
                // TODO: - 근무지명 받아오기
                Text("제이든의 낚시교실")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                    .padding(.leading, 3)
                Spacer()
                // TODO: - 근무 시간 받아오기
                Text("\(4)시간")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.horizontal, 4)
        }
        
        var cellContent: some View {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 요일 처리
                Text("\(10)월 \(8)일 금요일")
                    .font(.caption)
                    .foregroundColor(Color.fontBlack)
                // TODO: - 시간 처리, Int로 저장된 값을 String 두 단어로 처리하는 것은 찾아봐야 함
                Text("17시 00분 ~ 21시 00분")
                    .font(.caption2)
                    .foregroundColor(Color.fontLightGray)
            }
        }
        
        var cellButton: some View {
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
                                .fill(Color("PointRed"))
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

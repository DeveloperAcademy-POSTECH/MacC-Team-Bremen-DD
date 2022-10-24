//
//  WorkSpaceCreateCreatingScheduleView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

struct WorkSpaceCreateCreatingScheduleView: View {
    @ObservedObject var viewModel:  WorkSpaceCreateCreatingScheduleViewModel
    @Binding var isShowingModal: Bool
    @Binding var scheduleList: [Schedule]
    
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                guidingText
                workDayPicker
                workTimePicker
                Spacer()
            }
            .navigationBarTitle(Text("근무 일정 추가하기"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    toolbarCancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isShowingConfirmButton {
                        toolbarConfirmButton
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

private extension WorkSpaceCreateCreatingScheduleView {
    // 툴바 버튼들
    var toolbarCancelButton: some View {
        Button{
            self.isShowingModal = false
        } label: {
            Text("취소")
            .foregroundColor(.fontLightGray)
        }
    }
    var toolbarConfirmButton: some View {
        Button{
            // TODO: 넣기 전 데이터를 가공하는게 필요함
            scheduleList.append(Schedule(workDays: viewModel.getDayList() ,startHour: viewModel.startHour, startMinute: viewModel.endMinute, endHour: viewModel.endHour, endMinute: viewModel.endMinute))
            self.isShowingModal = false
        } label: {
            Text("완료")
        }
    }
    var guidingText: some View {
        Text("근무 요일과 시간을 입력해주세요.")
            .padding(.top, 40)
            .foregroundColor(.fontBlack)
    }
    var workDayPicker: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("근무 요일")
                .font(.caption)
                .foregroundColor(.fontLightGray)
            HStack(spacing: 8) {
                // 더 깔끔한 방식으로 하는 방법은 없을까?
                ForEach(0 ..< viewModel.sevenDays.count, id: \.self) { index in
                    Button {
                        viewModel.didTapDayPicker(index: index)
                    } label: {
                        DayButtonSubView(day: viewModel.sevenDays[index].dayName, isSelected: viewModel.sevenDays[index].isSelected)
                    }
                }
            }
        }
    }
    
    var workTimePicker: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("근무 시간")
                .font(.caption)
                .foregroundColor(.fontLightGray)
            HStack(spacing: 0) {
                // TODO: 컨포넌트 적용
                TextField("00", text: $viewModel.startHour)
                Text(":")
                TextField("00", text: $viewModel.startMinute)
                Text("-")
                    .padding(.horizontal, 10)
                TextField("00", text: $viewModel.endHour)
                Text(":")
                TextField("00", text: $viewModel.endMinute)
            }
            .foregroundColor(.fontBlack)
        }
    }
}

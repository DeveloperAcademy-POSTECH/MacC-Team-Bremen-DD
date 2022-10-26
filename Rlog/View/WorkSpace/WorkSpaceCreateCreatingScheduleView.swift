//
//  WorkSpaceCreateCreatingScheduleView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

struct WorkSpaceCreateCreatingScheduleView: View {
    @ObservedObject private var viewModel:  WorkSpaceCreateCreatingScheduleViewModel
    
    init(isShowingModal: Binding<Bool>, scheduleList: Binding<[ScheduleModel]>) {
        self.viewModel = WorkSpaceCreateCreatingScheduleViewModel(isShowingModal: isShowingModal, scheduleList: scheduleList)
    }
    
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
            viewModel.isShowingModal = false
        } label: {
            Text("취소")
            .foregroundColor(.fontLightGray)
        }
    }
    var toolbarConfirmButton: some View {
        Button{
            viewModel.didTapConfirmButton()
        } label: {
            Text("완료")
        }
    }
    var guidingText: some View {
        TitleSubView(title: "근무 요일과 시간을 입력해주세요.")
            .padding(.top, 20)
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
                // -------> TODO: 컨포넌트로 대체

                TextField("00", text: $viewModel.startHour)
                    .keyboardType(.decimalPad)
                // <------- TODO: 컨포넌트로 대체
                Text(":")
                // -------> TODO: 컨포넌트로 대체

                TextField("00", text: $viewModel.startMinute)
                    .keyboardType(.decimalPad)
                // <------ TODO: 컨포넌트로 대체

                Text("-")
                    .padding(.horizontal, 10)
//                if viewModel.isShowingOverSingleDay {
//                    Text("익일")
//                        .font(.caption)
//                        .foregroundColor(.fontDarkGray)
//                }
                // -------> TODO: 컨포넌트로 대체
                TextField("00", text: $viewModel.endHour)
                    .keyboardType(.decimalPad)
                // <------- TODO: 컨포넌트로 대체
                Text(":")
                // -------> TODO: 컨포넌트로 대체
                TextField("00", text: $viewModel.endMinute)
                    .keyboardType(.decimalPad)
                // <------- TODO: 컨포넌트로 대체

            }
            .foregroundColor(.fontBlack)
            Text(viewModel.errorMessage)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
    
    private struct DayButtonSubView: View {
        
        let day: String
        let isSelected: Bool
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.accentColor)
                    .opacity(isSelected ? 1 : 0)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color(red: 0.769, green: 0.769, blue: 0.769), lineWidth: 1)
                    .opacity(isSelected ? 0 : 1)
                Text(day)
                    .foregroundColor(isSelected ? .white : .fontBlack)
            }
            .frame(height: 60)
        }
    }
}

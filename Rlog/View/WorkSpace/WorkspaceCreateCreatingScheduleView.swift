//
//  WorkSpaceCreateCreatingScheduleView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/24.
//

import SwiftUI

struct WorkspaceCreateCreatingScheduleView: View {
    @ObservedObject private var viewModel:  WorkspaceCreateCreatingScheduleViewModel
    
    init(isShowingModal: Binding<Bool>, scheduleList: Binding<[ScheduleModel]>) {
        self.viewModel = WorkspaceCreateCreatingScheduleViewModel(isShowingModal: isShowingModal, scheduleList: scheduleList)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                TitleSubView(title: "근무 요일과 시간을 입력해주세요.")
                workDayPicker
                workTimePicker
                Spacer()
            }
            .navigationBarTitle(Text("근무패턴 생성"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    toolbarCancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarConfirmButton
                }
            }
            .padding(.horizontal)
        }
    }
}

private extension WorkspaceCreateCreatingScheduleView {
    var workDayPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("근무 요일")
                .font(.caption)
                .foregroundColor(.grayMedium)
            HStack(spacing: 8) {
                ForEach(0 ..< viewModel.sevenDays.count, id: \.self) { index in
                    Button {
                        viewModel.didTapDayPicker(index: index)
                    } label: {
                        DayButtonSubView(
                            day: viewModel.sevenDays[index].dayName,
                            isSelected: viewModel.sevenDays[index].isSelected
                        )
                    }
                }
            }
        }
        
    }
    
    var workTimePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 컴포넌트 적용 예정으로, 스페이싱이 어긋나있을 수 있습니다.
            Text("근무 시간")
                .font(.caption)
                .foregroundColor(.grayMedium)

            VStack(spacing: 24) {
                /* TODO: 하기 코드로 변경 필요
                 BorderedPicker(
                     date: $viewModel.startTime,
                     isTapped: $viewModel.isStartTimePickerActive,
                     type: .startTime
                 )
                 BorderedPicker(
                     date: $viewModel.endTime,
                     isTapped: $viewModel.isEndTimePickerActive,
                     type: .endTime
                 )
                 */
                BorderedPicker(
                    date: $viewModel.startTime,
                    type: .startTime
                )
                BorderedPicker(
                    date: $viewModel.endTime,
                    type: .endTime
                )
            }
        }
    }
    
    // 툴바 버튼들
    var toolbarCancelButton: some View {
        Button{
            viewModel.isShowingModal = false
        } label: {
            Text("취소")
                .foregroundColor(.grayLight)
        }
    }
    var toolbarConfirmButton: some View {
        Button{
            viewModel.didTapConfirmButton()
        } label: {
            Text("완료")
                .foregroundColor(viewModel.isActivatedConfirmButton ? .primary : .grayLight)
        }
    }
    
    private struct DayButtonSubView: View {
        
        let day: String
        let isSelected: Bool
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(isSelected ? .primary : .backgroundCard)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.backgroundStroke, lineWidth: 2)
                    .opacity(isSelected ? 0 : 1)
                Text(day)
                    .foregroundColor(isSelected ? .white : .grayMedium)
            }
            .frame(height: 54)
        }
    }
}
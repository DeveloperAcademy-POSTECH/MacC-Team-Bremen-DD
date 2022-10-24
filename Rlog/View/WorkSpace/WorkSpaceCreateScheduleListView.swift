//
//  WorkSpaceCreateScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

import SwiftUI

struct WorkSpaceCreateScheduleListView: View {
    @ObservedObject var viewModel = WorkSpaceCreateScheduleListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            guidingText
            labelText
            VStack(spacing: 16) {
                ForEach(viewModel.scheduleList, id: \.self) { item in
                    createScheduleListCell(for: item)
                    // TODO: 컨포넌트로 대체하기
                }
                addScheduleButton
            }
            Spacer()
            
        }
        .padding()
    }
}

private extension WorkSpaceCreateScheduleListView {
    @ViewBuilder
    func createScheduleListCell(for item: Schedule) -> some View {
        HStack {
            ForEach(item.workDays,id: \.self) { day in
                Text("\(day) ")
            }
            Spacer()
            Text("\(item.startHour):\(item.startMinute) - \(item.endHour):\(item.endMinute)")
        }
        .padding()
        .background(Color(red: 0.962, green: 0.962, blue: 0.962))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    var guidingText: some View {
        Text("근무 일정을 입력해주세요.")
            .padding(.vertical, 20)
    }
    var labelText: some View {
        Text("근무 유형")
            .font(.caption)
            .foregroundColor(.fontLightGray)
    }
    var addScheduleButton: some View {
        // TODO: 컨포넌트로 대체하기
        Button {
            viewModel.didTapAddScheduleButton()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 58)
                    .foregroundColor(.fontLightGray)
                Text("+ 근무 일정 추가하기")
                    .foregroundColor(.white)
            }
            .sheet(isPresented: $viewModel.isShowingModal) {
                WorkSpaceCreateCreatingScheduleView(isShowingModal: $viewModel.isShowingModal, scheduleList: $viewModel.scheduleList)
            }
        }
    }
}

struct WorkSpaceCreateScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceCreateScheduleListView()
    }
}

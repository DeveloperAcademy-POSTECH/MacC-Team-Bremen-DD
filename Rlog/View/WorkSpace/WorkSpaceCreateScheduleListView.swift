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
                //리스트 불러와서 반복문으로 돌리기
                ForEach(viewModel.scheduleList, id: \.self) { s in
                    scheduleItem(s)
                    //컨포넌트로 대체하기
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxHeight: 56)
                }
                addScheduleButton
            }
            Spacer()
            
        }
        .padding()
    }
}

private extension WorkSpaceCreateScheduleListView {
    var guidingText: some View {
        Text("근무 요일과 시간을 입력해주세요.")
            .padding(.vertical, 20)
    }
    var labelText: some View {
        Text("근무 유형")
            .font(.caption)
            .foregroundColor(.fontLightGray)
    }
    var addScheduleButton: some View {
        //컨포넌트로 대체하기
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
                Rectangle()
            }
        }
    }
}

struct WorkSpaceCreateScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceCreateScheduleListView()
    }
}

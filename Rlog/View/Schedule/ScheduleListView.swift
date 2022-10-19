//
//  ScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleListView: View {
    @State private var isShowUpcoming = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header
                    .padding(.top, 32)
                    .padding(.leading, 7)
                scheduleList
                    .padding(.top, 36)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // TODO: - 커스텀 토글 버튼
            Button(action: {
                isShowUpcoming.toggle()
            }, label: {
                Text("Test")
            })
            .padding(.bottom, 16)
        }
    }
}

private extension ScheduleListView {
    var header: some View {
        HStack(spacing: 0) {
            Image(systemName: "chevron.backward")
            // TODO: - 연도와 월 받아오기
            Text("2022.10")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.fontBlack)
                .padding(.horizontal, 10)
            Image(systemName: "chevron.right")
            Spacer()
        }
    }
    
    var scheduleList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                scheduleListHeader
                // TODO: - 리스트 cell 구현
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 97)
                        .foregroundColor(isShowUpcoming ? Color.green : Color.red)
                }
                .padding(.top, 16)
            }
        }
    }
    
    var scheduleListHeader: some View {
        HStack(spacing: 0) {
            // TODO: - 체크 아이콘 수정
            Image(systemName: "checkmark")
                .foregroundColor(Color.green)
            Text(isShowUpcoming ? "예정된 알바" : "지나간 알바")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.fontBlack)
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
    }
}

//
//  ScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleListView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                    .padding(.top, 32)
                    .padding(.leading, 7)
                upcomingList
                    .padding(.top, 36)
                Spacer()
            }
            .padding(.horizontal, 16)
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
    
    var upcomingList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                upcomingListHeader
                // TODO: - 리스트 cell 구현
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 97)
                }
                .padding(.top, 16)
            }
        }
    }
    
    var upcomingListHeader: some View {
        HStack(spacing: 0) {
            // TODO: - 체크 아이콘 수정
            Image(systemName: "checkmark")
                .foregroundColor(Color.green)
            Text("예정된 일정")
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

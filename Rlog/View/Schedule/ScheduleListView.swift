//
//  ScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject var viewModel = ScheduleListViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header
                    .padding(.top, 32)
                    .padding(.leading, 7)
                scheduleList
                    .padding(.top, 36)
            }
            .padding(.horizontal)
            
            // TODO: - #888888 컬러 추가
            Rectangle()
                .fill(LinearGradient(colors: [Color.clear, Color.fontLightGray], startPoint: .top, endPoint: .bottom))
                .frame(height: 83)
            
            StatusPicker(viewModel: viewModel)
                .frame(width: 176, height: 40)
                .padding(.bottom)
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
                        .foregroundColor(viewModel.selectedScheduleCase == .upcoming ? Color.green : Color.red)
                }
                .padding(.top)
            }
        }
    }
    
    var scheduleListHeader: some View {
        HStack(spacing: 0) {
            Image(systemName: "checkmark")
                .foregroundColor(Color.primary)
                .fontWeight(.bold)
            Text(viewModel.selectedScheduleCase.rawValue)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.fontBlack)
                .padding(.leading, 5)
        }
    }
}

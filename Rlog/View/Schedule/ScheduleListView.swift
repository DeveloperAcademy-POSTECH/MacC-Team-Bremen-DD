//
//  ScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum ScheduleCase: String, CaseIterable {
    case upcoming = "예정된 알바"
    case past = "지나간 알바"
}

struct ScheduleListView: View {
    @State private var scheduleListTitle = ScheduleCase.upcoming.rawValue
    private var scheduleCases = ScheduleCase.allCases.map { $0.rawValue }
    
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
            
            // TODO: - #888888 컬러 추가
            Rectangle()
                .fill(LinearGradient(colors: [Color.clear, Color.fontLightGray], startPoint: .top, endPoint: .bottom))
                .frame(height: 83)
            
            CustomPicker(selectedCase: $scheduleListTitle, options: scheduleCases)
                .frame(width: 176, height: 40)
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
                        .foregroundColor(scheduleListTitle == ScheduleCase.upcoming.rawValue ? Color.green : Color.red)
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
                .fontWeight(.bold)
            Text(scheduleListTitle)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.fontBlack)
                .padding(.leading, 5)
        }
    }
}

private struct CustomPicker: View {
    @Binding var selectedCase: String
    var options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(Color.green)
                        .cornerRadius(20)
                        .opacity(selectedCase == option ? 1 : 0.01)
                        .frame(width: selectedCase == option ? 97 : 79)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                selectedCase = option
                            }
                        }
                }
                .overlay(
                    Text(option)
                        .font(.caption2)
                        .fontWeight(selectedCase == option ? .bold : .regular)
                        .foregroundColor(selectedCase == option ? .white : Color.fontBlack)
                )
            }
        }
        .cornerRadius(20)
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
    }
}

//
//  ScheduleUpdateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/11/18.
//

import SwiftUI

struct ScheduleUpdateView: View {
    //뷰모델에서, Coredata에서 불러온 데이터를 사용해야합니다.
    @State private var date = Date()
    @State private var date2 = Date()
    @State private var date3 = Date()
    
    var body: some View {
        VStack(spacing: 24) {
            workspace
            workdate
            components
            memo
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

private extension ScheduleUpdateView {
    var workspace: some View {
        
        //TODO : picker로 변경
        InputFormElement(
            containerType: .workplace,
            text: .constant("디팍의 팍팍이")
        )
        .disabled(true)
    }
    
    var workdate: some View {
        VStack(spacing: 8) {
            HStack {
                Text("근무 날짜")
                    .font(.caption)
                    .foregroundColor(.grayMedium)
                Spacer()
            }
            
            BorderedPicker(
                date: $date,
                type: .date
            )
            .disabled(true)
        }
    }
    
    var components: some View {
        VStack(spacing: 16) {
            HStack {
                Text("근무 시간")
                    .font(.caption)
                    .foregroundColor(.grayMedium)
                Spacer()
            }
            
            BorderedPicker(
                date: $date2,
                type: .startTime
            )
            
            BorderedPicker(
                date: $date3,
                type: .endTime
            )
        }
    }
    
    var memo: some View {
        InputFormElement(
            containerType: .none(title: "메모 (선택사항)"),
            text: .constant("hello")
        )
    }
}

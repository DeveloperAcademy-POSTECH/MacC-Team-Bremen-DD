//
//  ScheduleCreationView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

struct ScheduleCreationView: View {
    @ObservedObject var viewModel = ScheduleCreationViewModel()
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

private extension ScheduleCreationView {
    var workspace: some View {
        
        //TODO : picker로 변경
        InputFormElement(
            containerType: .workplace,
            text: .constant("근무지를 선택해주세요.")
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

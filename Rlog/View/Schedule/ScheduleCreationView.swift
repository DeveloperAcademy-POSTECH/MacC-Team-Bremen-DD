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
        VStack(spacing: 20) {
            workspace
            workdate
            components
            memo
            HDivider()
            deleteButton
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

private extension ScheduleCreationView {
    var workspace: some View {
        InputFormElement(
            containerType: .workplace,
            text: .constant("Park's park park")
        )
        .disabled(true)
    }
    
    var workdate: some View {
        VStack(spacing: 8) {
            HStack {
                Text("근무 날짜")
                    .foregroundColor(.grayLight)
                    .font(.subheadline)
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
                    .foregroundColor(.grayLight)
                    .font(.subheadline)
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
            containerType: .none(title: "메모"),
            text: .constant("hello")
        )
    }
    
    var deleteButton: some View {
        StrokeButton(
            label: "근무 삭제하기",
            buttonType: .destructive) {
                
            }
    }
}

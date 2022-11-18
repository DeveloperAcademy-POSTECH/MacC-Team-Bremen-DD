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
    @State private var isAlertOpen = false

    var body: some View {
        VStack(spacing: 24) {
            workspace
            workdate
            components
            memo
            HDivider()
            
            StrokeButton(label: "근무지 삭제", buttonType: .destructive) {
                isAlertOpen.toggle()
            }
            .alert("근무지 삭제", isPresented: $isAlertOpen) {
                Button("취소", role: .cancel) {
                }
                Button("삭제", role: .destructive) {
                }
            } message: {
                Text("해당 근무지를 삭제합니다?")
            }
            .padding(.top, -8)
            
            Spacer()
        }
        .navigationBarTitle(Text("근무 수정"), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarConfirmButton
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

private extension ScheduleUpdateView {
    var toolbarConfirmButton: some View {
        Button{
        } label: {
            Text("완료")
                .foregroundColor(.primary)
        }
    }
    
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

//
//  ScheduleContainer.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/25.
//

import SwiftUI

struct ScheduleContainer: View {
    let repeatedSchedule: [String]
    let startHour: Int16
    let startMinute: Int16
    let endHour: Int16
    let endMinute: Int16
    
    var completion: (() -> Void)?
    
    var body: some View {
        scheduleContainerView
    }
}

private extension ScheduleContainer {
    var scheduleContainerView: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            // TODO: lightGray 세팅 필요
            .foregroundColor(.backgroundCard)
            .overlay {
                scheduleInformationView
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.backgroundStroke, lineWidth: 2)
            }
    }
    
    var scheduleInformationView: some View {
        HStack(spacing: 0) {
            repeatedScheduleView
            
            Spacer()
            
            workHourView
            
            Button{
                if let completion = completion {
                    completion()
                }
            } label: {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
            }.padding(.leading)
        }
        .padding()
    }
    
    var repeatedScheduleView: some View {
        HStack {
            ForEach(repeatedSchedule, id: \.self) { day in
                Text(day)
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            }
        }
    }
    
    var workHourView: some View {
        HStack(alignment: .top) {
            // 시간이 n시 0분인 경우 두 자릿수인 00으로 표시
            if startMinute < 30 {
                Text("\(startHour):\(startMinute)0")
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            } else {
                Text("\(startHour):\(startMinute)")
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            }
            
            Text("-")
            
            if endMinute < 30 {
                Text("\(endHour):\(endMinute)0")
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            } else {
                Text("\(endHour):\(endMinute)")
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            }
            
            if startHour >= endHour {
                Text("+1")
                    .font(.caption)
                    .foregroundColor(.grayMedium)
                    .padding(.leading, -6)
            }
        }
    }
}

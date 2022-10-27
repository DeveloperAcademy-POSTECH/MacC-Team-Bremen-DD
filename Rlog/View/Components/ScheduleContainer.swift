//
//  ScheduleContainer.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/25.
//

import SwiftUI

struct ScheduleContainer: View {
    let repeatedSchedule: [String]
    let startHour: String
    let startMinute: String
    let endHour: String
    let endMinute: String
    
    var body: some View {
        scheduleContainerView
    }
}

private extension ScheduleContainer {
    var scheduleContainerView: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            // TODO: lightGray 세팅 필요
            .foregroundColor(.gray)
            .overlay { scheduleInformationView }
    }
    
    var scheduleInformationView: some View {
        HStack {
            repeatedScheduleView
            
            Spacer()
            
            workHourView
        }
        .padding()
    }
    
    var repeatedScheduleView: some View {
        HStack {
            ForEach(repeatedSchedule, id: \.self) { day in
                Text(day)
            }
        }
    }
    
    var workHourView: some View {
        HStack {
            // 시간이 n시 0분인 경우 두 자릿수인 00으로 표시
            if startMinute.count == 1 {
                Text("\(startHour):0\(startMinute)")
            } else {
                Text("\(startHour):\(startMinute)")
            }
            
            Text("-")
            
            if endMinute.count == 1 {
                Text("\(endHour):0\(endMinute)")
            } else {
                Text("\(endHour):\(endMinute)")
            }
        }
    }
}

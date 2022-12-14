//
//  BorderedPicker.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

enum BorderedPickerType {
    case date
    case startTime
    case endTime
    
    var title: String {
        switch self {
        case .date: return "날짜"
        case .startTime: return "출근 시간"
        case .endTime: return "퇴근 시간"
        }
    }
}

struct BorderedPicker: View {
    @Binding var date: Date
    // TODO: @Binding var isTapped: Bool 으로 변경 필요
    @Binding var isActive: Bool
    let type: BorderedPickerType
    var timeData: String {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let year = components.year ?? 2000
        let month = components.month ?? 1
        let day = components.day ?? 1
        let hour = components.hour ?? 9
        let minute = components.minute ?? 0
        
        if type == .date {
            return "\(year)년 \(month)월 \(day)일"
        } else {
            return "\(hour):\(minute < 10 ? "0\(minute)" : "\(minute)")"
        }
    }
    
    var body: some View {
        borderedPicker
    }
}

private extension BorderedPicker {
    var borderedPicker: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    if type == .date {
                        Text(timeData)
                        Spacer()
                    } else {
                        Text(type.title)
                        Spacer()
                        Text(timeData)
                    }
                }
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(Color.backgroundCard)
            .onTapGesture { withAnimation { isActive.toggle() } }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isActive ? Color.primary : Color.backgroundStroke,
                        lineWidth: 2
                    )
            }
            
            if isActive {
                wheelTimePicker
            }
        }
    }
    
    var wheelTimePicker: some View {
        DatePicker(
            "",
            selection: $date,
            displayedComponents: type != .date ? .hourAndMinute : .date
        )
        .datePickerStyle(.wheel)
        .background(.white)
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 30
        }
        .onDisappear {
            UIDatePicker.appearance().minuteInterval = 1
            isActive = false
        }
        .padding(.horizontal)
    }
}

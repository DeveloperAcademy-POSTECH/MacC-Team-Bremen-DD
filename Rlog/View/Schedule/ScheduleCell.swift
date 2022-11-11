//
//  ScheduleCell.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/11.
//

import SwiftUI

struct ScheduleCell: View {
    // WorkspaceEntity
    @ObservedObject var viewModel = ScheduleListViewModel()
    let currentDate: Date
    let data: WorkspaceEntity
    var weekday: String {
        let formatter = DateFormatter(dateFormatType: .weekday)
        return formatter.string(from: currentDate)
    }
    // 👀 임시 뷰모델 로직
    var workType: (String, Color) {
        return viewModel.defineWorkType(
            repeatDays: data.schedules.repeatDays,
            workDate: data.workdays.date,
            startHour: data.schedules.startHour,
            startMinute: data.schedules.startMinute,
            endHour: data.schedules.endHour,
            endMinute: data.schedules.endMinute,
            spentHour: data.workdays.spentHour
        )
    }
    
    var body: some View {
        if data.schedules.repeatDays.contains(weekday) {
            scheduleInfo
                .transition(AnyTransition.opacity.animation(.easeInOut))
        } else {
            Text("No Schedule Found")
                .frame(maxWidth: .infinity)
                .transition(AnyTransition.opacity.animation(.easeInOut))
        }
    }
}

private extension ScheduleCell {
    var scheduleInfo: some View {
        VStack(spacing: 0) {
            HStack {
                Text(workType.0)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(workType.1)
                    .cornerRadius(5)
                Spacer()
                Text("\(data.workdays.spentHour)시간")
                    .font(.subheadline)
            }
            .padding(.bottom, 8)
            
            HStack {
                Text("\(data.name)")
                    .font(.body)
                Spacer()
                Text("\(data.workdays.startHour):\(data.workdays.startMinute) ~ \(data.workdays.endHour):\(data.workdays.endMinute)")

            }
            HStack {
                Spacer()
                Button {
                    print(viewModel.currentDate)
                    print(weekday)
                } label: {
                    Text("확정하기")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 29)
                        .padding(.vertical, 5)
                        .background(workType.1)
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 8)

        }
        .padding(.horizontal)
        .padding(.top, 19)
        .padding(.bottom, 8)
        .background(.gray)
        .cornerRadius(7.5)
        .padding(2)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .transaction { transaction in
            transaction.disablesAnimations = true
        }

    }
}

struct WorkspaceEntity: Identifiable {
    var id = UUID()
    
    let name: String
    let payDay: Int16 = 25
    let hourlyWage: Int32 = 10000
    let hasTax: Bool = true
    let hasJuhyu: Bool = true
    let schedules: ScheduleEntity
    let workdays: WorkdayEntity
}

struct ScheduleEntity {
    let repeatDays: [String] = ["월", "수", "금"]
    let startHour: Int16 = 9
    let startMinute: Int16 = 30
    let endHour: Int16 = 18
    let endMinute: Int16 = 0
}

struct WorkdayEntity {
    let date: Date
    let hourlyWage: Int32 = 10000
    let startHour: Int16 = 9
    let startMinute: Int16 = 30
    let endHour: Int16
    let endMinute: Int16 = 0
    var spentHour: Int16 {
        return endHour - startHour
    }
}

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
    let data: WorkspaceEntitySample
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
            scheduleInfo
                .transition(AnyTransition.opacity.animation(.easeInOut))
    }
}

private extension ScheduleCell {
    var scheduleInfo: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text(workType.0)
                    .font(.caption2)
                    .foregroundColor(Color.backgroundWhite)
                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .background(workType.1)
                    .cornerRadius(5)
                
                Spacer()
                
                Text("\(data.workdays.spentHour)시간")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            
            HStack {
                Text("\(data.name)")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                
                Spacer()
                
//                Text("\(data.workdays.startHour):\(data.workdays.startMinute) ~ \(data.workdays.endHour):\(data.workdays.endMinute)")
                Text(data.workdays.sampleWorkday)
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.vertical, 8)
            
            HStack {
                Spacer()
                
                Button {
                    print(viewModel.currentDate)
                    print(weekday)
                } label: {
                    
                    Text("확정하기")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.backgroundWhite)
                        .padding(EdgeInsets(top: 8, leading: 47, bottom: 8, trailing: 47))
                        .background(workType.1)
                        .cornerRadius(10)
                }
            }

        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .background(Color.backgroundCard)
        .cornerRadius(10)
        .padding(2)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.backgroundStroke, lineWidth: 2)
        }
    }
    
    var scheduleNotFound: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("rlogGreenLogo")
                .padding(.bottom, 24)
            Text("예정된 근무일정이 없습니다.")
                .font(Font.body.bold())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height / 2)
    }
}

struct WorkspaceEntitySample: Identifiable {
    var id = UUID()
    
    let name: String
    let payDay: Int16 = 25
    let hourlyWage: Int32 = 10000
    let hasTax: Bool = true
    let hasJuhyu: Bool = true
    let schedules: ScheduleEntitySample
    let workdays: WorkdayEntitySample
}

struct ScheduleEntitySample {
    let repeatDays: [String] = ["월", "수", "금"]
    let startHour: Int16 = 9
    let startMinute: Int16 = 30
    let endHour: Int16 = 18
    let endMinute: Int16 = 0
}

struct WorkdayEntitySample {
    let date: Date
    let sampleWorkday: String
    let hourlyWage: Int32 = 10000
    let startTime: Date = Date()
    let endTime: Date = Date()
    let hasDone: Bool
    var spentHour: Int16 = 4
}

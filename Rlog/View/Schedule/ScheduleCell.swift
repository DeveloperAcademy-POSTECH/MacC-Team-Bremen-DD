//
//  ScheduleCell.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/11.
//

import SwiftUI

struct ScheduleCell: View {
    // WorkspaceEntity
    let viewModel = ScheduleCellViewModel()
    let currentDate: Date
    let data: WorkdayEntity
    var weekday: String {
        let formatter = DateFormatter(dateFormatType: .weekday)
        return formatter.string(from: currentDate)
    }
    // 👀 임시 뷰모델 로직
    var workType: (String, Color) {
        return viewModel.defineWorkType(
            repeatDays: data.schedule?.repeatDays ?? [],
            data: data
        )
    }
    
    var spentHour: String {
        let result = viewModel.getSpentHour(data.endTime, data.startTime)
        var spentHour = ""
        
        if result.1 < 30 {
            spentHour = "\(result.0)시간"
        } else {
            spentHour = "\(result.0)시간 \(result.1)분"
        }
        
        return spentHour
    }
    
    var startTimeString: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: data.startTime)
        let hour = components.hour!
        let minute = components.minute!
        
        return "\(hour):\(minute >= 10 ? minute.description : "0\(minute)")"
    }
    
    var endTimeString: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: data.endTime)
        let hour = components.hour!
        let minute = components.minute!
        
        return "\(hour):\(minute >= 10 ? minute.description : "0\(minute)")"
    }
    
    var hasDone: Bool {
        return viewModel.verifyIsScheduleExpired(endTime: data.endTime)
    }
    
    var body: some View {
        scheduleInfo
            .transition(AnyTransition.opacity.animation(.easeInOut))
            .onAppear { print(data) }
    }
}

private extension ScheduleCell {
    var scheduleInfo: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("\(String(describing: data.hasDone))")
                Text(workType.0)
                    .font(.caption2)
                    .foregroundColor(Color.backgroundWhite)
                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .background(workType.1)
                    .cornerRadius(5)
                
                Spacer()
                
                Text(spentHour)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            
            HStack {
                Text("\(data.workspace.name)")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                
                Spacer()
                
                Text("\(startTimeString) ~ \(endTimeString)")
                    .font(.body)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.vertical, 8)
            
            if !hasDone && !data.hasDone {
                confirmationButton
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
    
    var confirmationButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.didTapConfirmationButton(data)
            } label: {
                Text("확정하기")
                    .font(Font.caption.bold())
                    .padding(EdgeInsets(top: 5, leading: 29, bottom: 5, trailing: 29))
                    .foregroundColor(.white)
                    .background(workType.1)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 8)
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

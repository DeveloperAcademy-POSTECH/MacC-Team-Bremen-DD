//
//  ScheduleCell.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/11.
//

import SwiftUI

// Sample
final class ScheduleCellViewModel {
    let timeManager = TimeManager()
    
    func defineWorkType(
        repeatDays: [String],
        workDate: Date,
        startHour: Int16,
        startMinute: Int16,
        endHour: Int16,
        endMinute: Int16,
        spentHour: Int16
    ) -> (type: String, color: Color) {
        let weekday = timeManager.getWeekdayOfDate(workDate)
        let spentHourOfNormalCase: Int16 = endHour - startHour
        let timeDifference = spentHour - spentHourOfNormalCase
        
        for day in repeatDays {
            if day != weekday { return ("추가", .blue) }
        }
        
        switch timeDifference {
        case 0:
            return ("정규", Color.primary)
        case 1...:
            return ("연장", Color.pointBlue)
        case _ where timeDifference < 0:
            return ("축소", Color.pointRed)
        default:
            return ("정규", .green)
        }
    }
    
    func verifyIsScheduleExpired(endTime: Date) -> Bool {
        let order = NSCalendar.current.compare(Date(), to: endTime, toGranularity: .minute)
        switch order {
        case .orderedDescending:
            return true
        default:
            return false
        }
    }
    
    func didTapConfirmationButton(_ data: WorkdayEntity) {
        // TODO: CoreData WorkdayEntity Edit 함수 적용
        print("🔥 Confirmation Button is Tapped")
        print(data.workspace.name)
        print("=====================================")
    }
}

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
            workDate: data.date,
            startHour: data.schedule?.startHour ?? 9,
            startMinute: data.schedule?.startMinute ?? 0,
            endHour: data.schedule?.endHour ?? 18,
            endMinute: data.schedule?.endMinute ?? 0,
            spentHour: 10
        )
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
    
    var isScheduleExpired: Bool {
        return viewModel.verifyIsScheduleExpired(endTime: data.endTime)
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
                
                Text("4시간")
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
            
            if isScheduleExpired {
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
                    .background(Color.primary)
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

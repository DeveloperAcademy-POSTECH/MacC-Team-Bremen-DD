//
//  WorkSpcaeList.swift
//  Rlog
//
//  Created by JungHoonPark on 2022/10/21.
//

import SwiftUI

struct WorkSpaceCell: View {
    
    var model: CustomModel
    
    var body: some View {
        NavigationLink {
            WorkSpaceDetailView()
        } label: {
            makeWorkSpaceCardContent(model: model)
        }
    }
}

private extension WorkSpaceCell {
    func makeWorkSpaceRowInfo(workTitle: String, workInfo: String) -> some View {
        HStack() {
            Text(workTitle)
                .font(.subheadline)
                .foregroundColor(.grayMedium)
            Spacer()
            Text(workInfo)
                .font(.subheadline)
                .foregroundColor(.fontBlack)
        }
    }
    
    //TODO : 뷰모델 연동시 사용 예정
    //    func makeWorkSpaceScheduleInfo() -> some View {
    //        HStack(alignment: .top, spacing: 0) {
    //            Text("workTitle")
    //                .font(.subheadline)
    //                .foregroundColor(.grayMedium)
    //            Spacer()
    //            VStack(spacing: 0) {
    //                ForEach(schedules) { schedule in
    //                    HStack(spacing: 0) {
    //                        HStack(spacing: 0) {
    //                            ForEach(schedule.repeatedSchedule, id:\.self) { week in
    //                                Text(week)
    //                                    .font(.subheadline)
    //                                    .foregroundColor(.fontBlack)
    //                                    .padding(.horizontal, 1)
    //                            }
    //                        }
    //                        .padding(.trailing, 3)
    //
    //                        Text("\(schedule.startHour):\(schedule.startMinute)0 - \(schedule.endHour):\(schedule.endMinute)0")
    //                            .font(.subheadline)
    //                            .foregroundColor(.fontBlack)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func makeWorkSpaceCardContent(model: CustomModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center){
                Rectangle()
                    .foregroundColor(Color.primary)
                    .frame(width: 4, height: 16)
                Text(model.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.fontBlack)
            }
            .padding(.bottom, 16)
            
            VStack(spacing: 8){
                makeWorkSpaceRowInfo(workTitle: "시급", workInfo: "\(String(model.hourlyWage)) 원")
                makeWorkSpaceRowInfo(workTitle: "급여일", workInfo: "매월 \(String(model.paymentDay)) 일")
                makeWorkSpaceRowInfo(workTitle: "주휴수당", workInfo: model.hasJuhyu ? "적용" : "미적용")
                makeWorkSpaceRowInfo(workTitle: "소득세", workInfo: model.hasTax ? "적용" : "미적용")
                //                makeWorkSpaceScheduleInfo(workTitle: "근무유형", schedules: schedules)
            }
        }
        .padding()
        .background(Color.backgroundCard)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.backgroundStroke, lineWidth: 2)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
    }
}


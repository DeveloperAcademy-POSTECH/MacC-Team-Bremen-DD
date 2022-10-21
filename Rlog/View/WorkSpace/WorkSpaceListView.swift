//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum WorkSpaceInfo: CaseIterable {
    case hourlyWage
    case paymentDay
    case hasJuhyu
    case hasTax
    case workDays
    
    var text: String {
        switch self {
        case .hourlyWage: return "시급"
        case .paymentDay: return "급여일"
        case .hasJuhyu: return "주휴수당"
        case .hasTax: return "소득세"
        case .workDays: return "근무 유형"
        }
    }
}

struct WorkSpaceListView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cardBackground
                
                ScrollView {
                    ForEach(models, id: \.self) { model in
                        NavigationLink(
                            destination: { WorkSpaceDetailView() },
                            label: { WorkSpaceCardContents(model: model) }
                        )
                    }
                }
                .padding(.top, 32)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("근무지")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { print("button pressed") }){
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

private extension WorkSpaceListView {
    func WorkSpaceCardHeader(workTitle: String, workTagColor: String) -> some View {
        HStack(alignment: .center){
            Rectangle()
                .foregroundColor(Color(workTagColor))
                .frame(width: 3, height: 17)
            Text(workTitle)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.fontBlack)
        }.padding(.bottom, 20)
    }
    
    func WorkSpaceCardContents(model: CustomModel) -> some View {
        ZStack{
            
            VStack(alignment: .leading, spacing: 0) {
                WorkSpaceCardHeader(workTitle: model.name, workTagColor: model.Color)
                
                VStack(spacing: 8){
                    ForEach(WorkSpaceInfo.allCases, id: \.self) { tab in
                        HStack() {
                            Text(tab.text)
                                .font(.subheadline)
                                .foregroundColor(.fontLightGray)
                            Spacer()
                            Text(model.text(info: tab))
                                .font(.subheadline)
                                .foregroundColor(.fontBlack)
                        }
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.background))
            .padding([.horizontal, .bottom])
        }
    }
}



struct CustomModel: Hashable {
    let name: String
    let hourlyWage: Int
    let date: String
    let hasJuhyu: Bool
    let hasTax: Bool
    let Color: String
    let workDays: String
    let schedules: String
    
    func text(info: WorkSpaceInfo) -> String {
        switch info {
        case .hourlyWage: return "\(hourlyWage)"
        case .paymentDay: return date
        case .hasJuhyu:
            return hasJuhyu ? "적용" : "미적용"
        case .hasTax:
            return hasTax ? "적용" : "미적용"
        case .workDays: return "\(workDays + " " + schedules)"
        }
    }
}

let models = [
    CustomModel(
        name: "팍이네 팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: true,
        hasTax: false,
        Color: "PointRed",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00"
    ),
    CustomModel(
        name: "팍이네 팍팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: false,
        hasTax: true,
        Color: "PointPink",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00"
    ),
    CustomModel(
        name: "팍이네 팍팍팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: true,
        hasTax: false,
        Color: "PointYellow",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00"
    ),
]

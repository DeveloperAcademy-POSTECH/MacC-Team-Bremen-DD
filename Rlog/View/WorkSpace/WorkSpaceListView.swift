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
    @ObservedObject var viewModel = WorkSpaceListViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                ForEach(models, id: \.self) { model in
                    WorkSpaceCell(model: model)
                }
                Text("")
            }
            .padding(.top, 24)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Text("근무지")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.fontBlack)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(
                        destination: WorkSpaceCreateView(isActive: $viewModel.isShowingSheet),
                        isActive: $viewModel.isShowingSheet) {
                        //TODO : SF심블이 아니므로 별도 PR에 assets 추가 후 적용 예정
                        Image("plus.curved")
                            .foregroundColor(Color.primary)
                    }
                }
            }
            .background(Color.backgroundWhite)
        }
    }
}

struct CustomModel: Hashable {
    
    let name: String
    let hourlyWage: Int
    let date: String
    let hasJuhyu: Bool
    let hasTax: Bool
    let color: String
    let workDays: String
    let schedules: String
    let paymentDay: Int
    
    // TODO: CoreData model에도 추가해야함.
    func getValue(info: WorkSpaceInfo) -> String {
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

// TODO: Data 주입 후, 삭제 해야함
let models = [
    CustomModel(
        name: "팍이네 팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: true,
        hasTax: false,
        color: "PointRed",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00",
        paymentDay:10
    ),
    CustomModel(
        name: "팍이네 팍팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: false,
        hasTax: true,
        color: "PointPink",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00",
        paymentDay:10
    ),
    CustomModel(
        name: "팍이네 팍팍팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: true,
        hasTax: false,
        color: "PointYellow",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00",
        paymentDay:10
    ),
    CustomModel(
        name: "팍이네 팍팍팍팍 감자탕",
        hourlyWage: 2000,
        date: "2022.07.11",
        hasJuhyu: true,
        hasTax: false,
        color: "PointYellow",
        workDays : "월, 화, 수, 목요일",
        schedules : "10:00 - 12:00",
        paymentDay:10
    )
]



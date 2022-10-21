//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI


struct WorkSpaceListView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cardBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    ForEach(models, id: \.self) { model in
                        WorkSpaceCell(model: model)
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
                                .fontWeight(.bold)
                        }
                    }
                }
            }
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

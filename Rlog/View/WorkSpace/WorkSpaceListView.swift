//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum WorkSpaceInfo: CaseIterable {
    case money
    case date
    case pay
    case tax
    case workType
    
    var text: String {
        switch self {
        case .money: return "시급"
        case .date: return "급여일"
        case .pay: return "주휴수당"
        case .tax: return "소득세"
        case .workType: return "근무 유형"
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
    func WorkSpaceCardHeader(workTitle: String) -> some View {
        HStack(alignment: .center){
            Rectangle()
                .fill(.primary)
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
                WorkSpaceCardHeader(workTitle: model.title)
                
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
    let title: String
    let money: Int
    let date: String
    let pay: String
    let tax: String
    let workType: String
    
    func text(info: WorkSpaceInfo) -> String {
        switch info {
        case .money: return "\(money)"
        case .date: return date
        case .pay: return "\(pay)"
        case .tax: return "\(tax)"
        case .workType: return "\(workType)"
        }
    }
}

let models = [
    CustomModel(
        title: "팍이네 팍팍 감자탕",
        money: 2000,
        date: "2022.07.11",
        pay: "미적용",
        tax: "미적용",
        workType : "월, 화, 수, 목요일 10:00 - 12:00"
    ),
    CustomModel(
        title: "팍이네 팍팍팍 감자탕",
        money: 2000,
        date: "2022.07.11",
        pay: "미적용",
        tax: "미적용",
        workType : "월, 화, 수, 목요일 10:00 - 12:00"
    ),
    CustomModel(
        title: "팍이네 팍팍팍팍 감자탕",
        money: 2000,
        date: "2022.07.11",
        pay: "미적용",
        tax: "미적용",
        workType : "월, 화, 수, 목요일 10:00 - 12:00"
    ),
]

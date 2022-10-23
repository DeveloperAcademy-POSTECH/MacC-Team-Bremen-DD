//
//  WorkSpcaeList.swift
//  Rlog
//
//  Created by JungHoonPark on 2022/10/21.
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

struct WorkSpaceCell: View {
    var model: CustomModel
    
    var body: some View {
        NavigationLink(
            destination: { WorkSpaceDetailView() },
            label: { makeWorkSpaceCardContent(model: model) }
        )
    }
}

private extension WorkSpaceCell {
    func makeWorkSpaceCardHeader(workTitle: String, workTagColor: String) -> some View {
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
    
    func makeWorkSpaceCardContent(model: CustomModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            makeWorkSpaceCardHeader(workTitle: model.name, workTagColor: model.color)
            
            VStack(spacing: 8){
                ForEach(WorkSpaceInfo.allCases, id: \.self) { tab in
                    HStack() {
                        Text(tab.text)
                            .font(.subheadline)
                            .foregroundColor(.fontLightGray)
                        Spacer()
                        Text(model.getValue(info: tab))
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




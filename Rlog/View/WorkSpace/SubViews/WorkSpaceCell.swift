//
//  WorkSpcaeList.swift
//  Rlog
//
//  Created by JungHoonPark on 2022/10/21.
//

import SwiftUI

struct WorkSpaceCell: View {
    var workspace: WorkspaceEntity
    
    var body: some View {
        NavigationLink {
            WorkSpaceDetailView(workspace: workspace)
        } label: {
            makeWorkSpaceCardContent(workspace: workspace)
        }
    }
}

private extension WorkSpaceCell {
        func makeWorkSpaceRowInfo(workTitle: String, workInfo: String) -> some View {
            HStack() {
                Text(workTitle)
                    .font(.subheadline)
                    .foregroundColor(.fontLightGray)
                Spacer()
                Text(workInfo)
                    .font(.subheadline)
                    .foregroundColor(.fontBlack)
            }
        }
    
    func makeWorkSpaceCardContent(workspace: WorkspaceEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center){
                Rectangle()
                    .foregroundColor(Color(workspace.colorString))
                    .frame(width: 3, height: 17)
                Text(workspace.name)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.fontBlack)
            }
            .padding(.bottom, 20)

            VStack(spacing: 8){
                makeWorkSpaceRowInfo(workTitle: "시급", workInfo: "\(String(workspace.hourlyWage)) 원")
                makeWorkSpaceRowInfo(workTitle: "급여일", workInfo: "매월 \(String(workspace.paymentDay)) 일")
                makeWorkSpaceRowInfo(workTitle: "주휴수당", workInfo: workspace.hasJuhyu ? "적용" : "미적용")
                makeWorkSpaceRowInfo(workTitle: "소득세", workInfo: workspace.hasTax ? "적용" : "미적용")
                makeWorkSpaceRowInfo(workTitle: "근무유형", workInfo: "근무유형 연결")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.background))
        .padding([.horizontal, .bottom])
    }
}




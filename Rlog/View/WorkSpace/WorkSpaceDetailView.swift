//
//  WorkSpaceDetailView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum WorkSpaceDetailInfo: CaseIterable {
    case hasTax
    case hasJuhyu
    
    var text: [String] {
        switch self {
        case .hasTax: return ["소득세", "3.3% 적용"]
        case .hasJuhyu: return ["주휴수당", "60시간 근무 시 적용"]
        }
    }
}

struct WorkSpaceDetailView: View {
    @State var model: CustomModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            //TODO : Rectangle 자리 공용 컴포넌트 삽입
            Rectangle() //근무지
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 68)
            Rectangle() //시급
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 68)
            Rectangle() //급여일
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 68)

            makePaymentSystemToggle()
            
            Rectangle() //근무유형
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 54)
            Rectangle() //일정추가 버튼
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 54)
            //디바이더
            Rectangle() //삭제 버튼
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 54)
            Spacer()
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }){
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                    .foregroundColor(.black)                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }){
                    Text("완료")
                        .fontWeight(.bold)
                }
            }
        }
        .background(Color.cardBackground)
        .navigationBarBackButtonHidden()
    }
}

private extension WorkSpaceDetailView {
    func makePaymentSystemToggle() -> some View {
        ForEach(WorkSpaceDetailInfo.allCases, id: \.self) { tab in
            Toggle(isOn: tab == .hasTax ? $model.hasJuhyu : $model.hasTax, label: {
                HStack(spacing: 13) {
                    Text(tab.text[0])
                        .font(.subheadline)
                        .foregroundColor(.fontLightGray)
                    Text(tab.text[1])
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
        }
    }
}



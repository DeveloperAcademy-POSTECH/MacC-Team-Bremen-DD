//
//  WorkSpaceCreateConfirmationView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

// TODO: 네비게이션 연결, 뷰모델 연결, 고민 공유, 컨포넌트 적용

import SwiftUI

struct WorkSpaceCreateConfirmationView: View {
    var body: some View {
        // 고민: 폭이 한계까지 닿지 않아서 가운데정렬이 되는데, 컨포넌트를 가져오면 해결된다. 이럴 경우 다른 방식으로 미뤄두는게 필요할까?
        VStack(alignment: .leading, spacing: 20) {
            TitleSubView(title: "새로운 아르바이트를 추가합니다.")
            WorkSpaceInfoSubView(labelName:"근무지", content:"팍이네 팍팍 감자탕")
            WorkSpaceInfoSubView(labelName:"시급", content:"9,250원")
            WorkSpaceInfoSubView(labelName:"급여일", content:"매월 10일")
            WorkSpaceInfoSubView(labelName:"주휴수당", content:"60시간 근무 시 적용")
            WorkSpaceInfoSubView(labelName:"근무지", content:"3.3% 적용")
            WorkTypeInfo(for: "haha")
            Spacer()
        }
        .padding()
    }
}

private extension WorkSpaceCreateConfirmationView {
    @ViewBuilder
    func WorkTypeInfo(for worktype: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("근무 유형")
                .font(.caption)
                .foregroundColor(.fontLightGray)
            // 컨포넌트에 일하는 유형을 넣어준다.
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 54)
        }
    }
}

struct WorkSpaceCreateConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceCreateConfirmationView()
    }
}



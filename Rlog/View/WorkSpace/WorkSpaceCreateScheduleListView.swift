//
//  WorkSpaceCreateScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//

import SwiftUI

struct WorkSpaceCreateScheduleListView: View {
    
    @State var isNavigationActivated: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            //타이틀 섭뷰 넣기 "근무 일정을 입력해주세요." Or "근무 유형을 추가해주세요!"
            Text("sample")
            labelText
            VStack(spacing: 16) {
                //리스트 불러와서 반복문으로 돌리기
                ForEach(1 ..< 3, id: \.self) { s in
                    //컨포넌트로 대체하기
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxHeight: 56)
                }
                //컨포넌트로 대체하기
                Button {} label: {
                    Text("+ 근무 일정 추가하기")
                }
            }
            Spacer()
            
        }
        .padding()
    }
}

private extension WorkSpaceCreateScheduleListView {
    var labelText: some View {
        Text("근무 유형")
            .font(.caption)
            .foregroundColor(.fontLightGray)
    }
}

struct WorkSpaceCreateScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceCreateScheduleListView()
    }
}

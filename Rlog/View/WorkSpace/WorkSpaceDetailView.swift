//
//  WorkSpaceDetailView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct WorkSpaceDetailView: View {
    var model: CustomModel
    
    var body: some View {
        VStack(spacing: 16) {
            //TODO : Rectangle 자리 공용 컴포넌트 삽입
            Rectangle() //근무지
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 68)
            Rectangle() //시급
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 68)
            Rectangle() //급여일
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 68)
            Rectangle() //근무유형
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 54)
            Rectangle() //일정추가 버튼
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 54)
            //디바이더
            Rectangle() //삭제 버튼
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 54)
        }
        .padding(.horizontal)
    }
}


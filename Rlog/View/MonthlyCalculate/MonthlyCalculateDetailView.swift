//
//  MonthlyCalculateDetailView.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/14.
//

import SwiftUI

struct MonthlyCalculateDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.top, 18)
                closing
                    .padding(.top, 39)
            }
            .padding(.horizontal)
        }
    }
}

private extension MonthlyCalculateDetailView {
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("GS25 포항공대점")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.fontBlack)
            Text("2022년 10월 25일 ~ 2022년 11월 24일")
                .font(.subheadline)
                .foregroundColor(Color.fontBlack)
            Text("정산일까지 D-12")
                .font(.caption2)
                .foregroundColor(Color.pointRed)
        }
    }
    
    var closing: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("결산")
                .font(.subheadline)
                .fontWeight(.bold)
            
            HStack {
                Text("일한 시간")
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("32시간")
                    .foregroundColor(Color.grayDark)
            }
            .font(.subheadline)
            .padding(.top, 4)
            
            HStack {
                Text("시급")
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("11,000원")
                    .foregroundColor(Color.grayDark)
            }
            .font(.subheadline)
            .padding(.bottom, 4)
            
            HDivider()
            
            HStack {
                Spacer()
                Text("352,000원")
            }
            .font(.subheadline)
            .foregroundColor(Color.grayDark)
            .padding(.top, 4)
            
            HStack {
                Text("주휴수당 적용됨")
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("70,400원")
                    .foregroundColor(Color.grayDark)
            }
            .font(.subheadline)
            
            HStack {
                Text("세금 3.3% 적용")
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("13,939원")
                    .foregroundColor(Color.grayDark)
            }
            .font(.subheadline)
            
            HStack {
                Text("총 급여")
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("422,400원")
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.top)
        }
    }
}

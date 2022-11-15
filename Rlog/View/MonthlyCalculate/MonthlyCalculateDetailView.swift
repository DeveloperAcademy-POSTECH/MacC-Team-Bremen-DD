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
            
            makeCalculationResult(title: "일한 시간", result: "\(32)시간")
                .padding(.top, 4)
            
            makeCalculationResult(title: "시급", result: "\(11000)원")
                .padding(.bottom, 4)
            
            HDivider()
            
            makeCalculationResult(title: nil, result: "\(352000)원")
                .padding(.top, 4)
            
            makeCalculationResult(title: "주휴수당 적용됨", result: "\(70400)원")
            
            makeCalculationResult(title: "세금 3.3% 적용", result: "\(13939)원")
            
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
    
    func makeCalculationResult(title: String?, result: String) -> some View {
        HStack {
            if let title = title {
                Text(title)
                    .foregroundColor(Color.grayMedium)
            }
            Spacer()
            Text(result)
                .foregroundColor(Color.fontBlack)
        }
        .font(.subheadline)
    }
}

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
                resonList
                    .padding(.top)
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
    
    var resonList: some View {
        VStack(alignment: .leading) {
            Text("상세정보")
                .font(.subheadline)
                .fontWeight(.bold)
            
            ForEach(1..<3) { _ in
                makeReasonCell()
            }
        }
    }
    
    func makeReasonCell() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                // TODO: - 컴포넌트로 바뀔 예정
                Text("추가")
                    .font(.caption2)
                    .foregroundColor(Color.backgroundWhite)
                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.pointPurple)
                    )
                Spacer()
                Text("4시간")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.top)
            
            HStack {
                Text("11월 7일")
                    .fontWeight(.bold)
                Spacer()
                Text("10:00 ~ 14:00")
            }
            .foregroundColor(Color.fontBlack)
            // TODO: - Padding 값도 reason의 유무에 따라 16, 8로 변경 될 예정
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            // TODO: - reason이 있을 때만, 보여지는 처리 필요
            Text("사장님이 오늘 아프셔서 대신 출근했다.")
                .font(.footnote)
                .foregroundColor(Color.grayMedium)
                .padding(.bottom)
        }
        .padding(.horizontal)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundCard)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.backgroundStroke, lineWidth: 2)
            }
        )
    }
}

struct MonthlyCalculateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalculateDetailView()
    }
}

//
//  MonthlyCalculateListView.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

struct MonthlyCalculateListView: View {
    @ObservedObject private var viewModel = MonthlyCalculateListViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.top, 24)
            total
                .padding(.top, 34)
            Spacer()
        }
        .padding(.horizontal)
    }
}

private extension MonthlyCalculateListView {
    var header: some View {
        HStack {
            Text("정산")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            // TODO: - 컴포넌트화 예정
            HStack(spacing: 8) {
                Button(action: {
                    // TODO: - ViewModel에서 로직 구현
                }, label: {
                    Image(systemName: "chevron.left")
                })
                // TODO: - 현재 연도, 월로 바꾸기
                Text(viewModel.date.fetchYearAndMonth())
                    .fontWeight(.semibold)
                Button(action: {
                    // TODO: - ViewModel에서 로직 구현
                }, label: {
                    Image(systemName: "chevron.right")
                })
            }
            .font(.title)
        }
        .foregroundColor(Color.fontBlack)
    }
    
    var total: some View {
        HStack {
            Text("\(viewModel.date.fetchMonth())월 총 금액")
            Spacer()
            Text("10,200,000원")
                .fontWeight(.bold)
        }
        .font(.title3)
        .foregroundColor(Color.fontBlack)
    }
}

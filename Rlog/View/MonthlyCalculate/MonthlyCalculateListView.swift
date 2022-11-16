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
        NavigationView {
            VStack(spacing: 0) {
                header
                    .padding(.top, 24)
                total
                    .padding(.top, 34)
                calculateByWorkspaceList
                    .padding(.top, 32)
                Spacer()
            }
            .padding(.horizontal)
        }
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
    
    var calculateByWorkspaceList: some View {
        VStack {
            ForEach(1..<3) { _ in
                CalculateByWorkspaceCell()
            }
        }
    }
    
    /* MARK: - 근무지에 해당하는 셀을 하위 struct로 만들어서 각 struct의 ViewModel이 값을 계산하게 할지 아니면 이 뷰가 전부 가지고 있을지를 고민하고 있습니다.
     따로 struct를 빼버리면, 근무지 별로 필요한 WorkDay를 갖고 있으므로, 코드와 데이터 처리가 깔끔해질 것 같고, 전체 금액 계산하기가 껄끄러워 질 수도 있을 것 같습니다.
     그래서, @escaping으로 계산 결과를 돌려 받아 월 전체 금액을 계산할지
     이 뷰가 그냥 함수형이나 변수로 뷰를 가지고 있으면 전체 월 계산이 편해지지 않을까까지 고민해봤습니다.
    */
    // TODO: - 하위 Struct가 아닌, function으로 처리할 예정, 정산 결과 관련된 로직은 아예 다른 Service로 뺄 예정
    private struct CalculateByWorkspaceCell: View {
        var body: some View {
            NavigationLink(destination: MonthlyCalculateDetailView()) {
                VStack(alignment: .leading, spacing: 0) {
                    workspaceTitle
                        .padding(.top)
                    Group {
                        makeWorkspaceInfomation(title: "일한 시간", content: "32시간")
                            .padding(.top, 32)

                        makeWorkspaceInfomation(title: "급여일까지", content: "D-12")
                            .padding(.top, 8)
                        
                        HDivider()
                            .padding(.top, 8)
                        
                        calculateResult
                            .padding(.vertical)
                    }
                    .padding(.leading, 4)
                }
                .padding(.horizontal)
                .background(Color.backgroundCard)
                .cornerRadius(8)
                .padding(2)
                .background(Color.backgroundStroke)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        
        var workspaceTitle: some View {
            HStack(spacing: 4) {
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: 16)
                Text("GS25 포항공대점")
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
        }
        
        var calculateResult: some View {
            HStack(alignment: .bottom) {
                Text("금액")
                    .font(.subheadline)
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("422,400원")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
        }
        
        func makeWorkspaceInfomation(title: String, content: String) -> some View {
            HStack {
                Text(title)
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text(content)
                    .foregroundColor(Color.grayDark)
            }
            .font(.subheadline)
        }
    }
}

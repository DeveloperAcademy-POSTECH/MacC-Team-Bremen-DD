//
//  MonthlyCalculateListView.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

struct MonthlyCalculateListView: View {
    @StateObject private var viewModel = MonthlyCalculateListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header
                    .padding(.top, 24)
                total
                    .padding(.top, 34)
                ScrollView {
                    calculateByWorkspaceList
                        .padding(.top, 32)
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
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
            YearMonthStepperCalendar(
                tapToPreviousMonth: {
                    viewModel.didTapPreviousMonth()
                },
                tapToNextMonth: {
                    viewModel.didTapNextMonth()
                },
                currentMonth: "\(viewModel.switchedDate.yearInt).\(viewModel.switchedDate.monthInt)"
            )
        }
        .foregroundColor(Color.fontBlack)
    }
    
    var total: some View {
        HStack {
            Text("\(viewModel.switchedDate.monthInt)월 총 금액")
            Spacer()
            Text("\(viewModel.monthlySalaryTotal)원")
                .fontWeight(.bold)
        }
        .font(.title3)
        .foregroundColor(Color.fontBlack)
    }
    
    var calculateByWorkspaceList: some View {
        VStack {
            ForEach(0..<viewModel.monthlyCalculateResults.count, id: \.self) { index in
                makeMonthlyCalculateListViewModel(monthlyCalculateResult: viewModel.monthlyCalculateResults[index])
            }
        }
    }
    
    func makeMonthlyCalculateListViewModel(monthlyCalculateResult: MonthlyCalculateResult) -> some View {
        var workspaceTitle: some View {
            HStack(spacing: 4) {
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: 16)
                Text(monthlyCalculateResult.workspace.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                Spacer()
                Text("\(monthlyCalculateResult.startDate.monthInt)월 \(monthlyCalculateResult.startDate.dayInt)일 ~ \(monthlyCalculateResult.endDate.monthInt)월 \(monthlyCalculateResult.endDate.dayInt)일")
                    .font(.caption)
                    .foregroundColor(Color.fontBlack)
            }
        }
        
        var calculateResult: some View {
            HStack(alignment: .bottom) {
                Text("금액")
                    .font(.subheadline)
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("\(monthlyCalculateResult.monthlySalary)원")
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
        
        return NavigationLink(destination: MonthlyCalculateDetailView(monthlyCalculateResult: monthlyCalculateResult)) {
            VStack(alignment: .leading, spacing: 0) {
                workspaceTitle
                    .padding(.top)
                Group {
                    makeWorkspaceInfomation(title: "일한 시간", content: "\(monthlyCalculateResult.workHours)시간")
                        .padding(.top, 32)
                    
                    if viewModel.fetchIsCurrentMonth() {
                        makeWorkspaceInfomation(title: "급여일까지", content: "D-\(monthlyCalculateResult.leftDays)")
                            .padding(.top, 8)
                    }
                    
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
}

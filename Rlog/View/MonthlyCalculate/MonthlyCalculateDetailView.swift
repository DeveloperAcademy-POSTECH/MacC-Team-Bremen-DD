//
//  MonthlyCalculateDetailView.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/14.
//

import SwiftUI

struct MonthlyCalculateDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MonthlyCalculateDetailViewModel
    
    init(monthlyCalculateResult: MonthlyCalculateResult) {
        _viewModel = StateObject(wrappedValue: MonthlyCalculateDetailViewModel(calculateResult: monthlyCalculateResult))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.top, 24)
                    .padding(.horizontal)
                closing
                    .padding(.top, 32)
                    .padding(.horizontal)
                calendarView
                    .padding(.top, 40)
                resonList
                    .padding(EdgeInsets(top: 32, leading: 16, bottom: 16, trailing: 16))

            }
        }
        .navigationBarTitle (Text("근무 정산"), displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
    }
}

private extension MonthlyCalculateDetailView {
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.calculateResult.workspace.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.fontBlack)
            if viewModel.current.monthInt == Date().monthInt {
                Text("정산일까지 D-\(viewModel.calculateResult.leftDays)")
                    .font(.caption2)
                    .foregroundColor(Color.pointRed)
            }
        }
    }
    
    var closing: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("결산")
                .font(.subheadline)
                .fontWeight(.bold)
            
            makeCalculationResult(title: "일한 시간", result: "\(viewModel.calculateResult.workHours)시간")
                .padding(.top, 4)
            
            makeCalculationResult(title: "시급", result: "\(viewModel.calculateResult.workspace.hourlyWage)원")
                .padding(.bottom, 4)
            
            HDivider()
            
            makeCalculationResult(title: nil, result: "\(viewModel.calculateResult.monthlySalaryWithoutTaxAndJuhyu)원")
                .padding(.top, 4)
            
            if viewModel.calculateResult.workspace.hasJuhyu {
                makeCalculationResult(title: "주휴수당 적용됨", result: "\(viewModel.calculateResult.juhyu)원")
            }
            
            if viewModel.calculateResult.workspace.hasTax {
                makeCalculationResult(title: "세금 3.3% 적용", result: "\(viewModel.calculateResult.tax)원")
            }
            
            HStack {
                Text("총 급여")
                    .foregroundColor(Color.grayMedium)
                Spacer()
                Text("\(viewModel.calculateResult.monthlySalary)원")
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.top)
        }
    }

    var calendarView: some View {
        VStack(spacing: 0) {
            calendarTitle
            VStack(spacing: 0) {
                calendarHeader
                calendarBody
                Spacer()
                calendarFooter
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.backgroundCard)
            .cornerRadius(10)
            .padding(2)
            .background(Color.backgroundStroke)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    var calendarTitle: some View {
        HStack(spacing: 16) {
            Text("근무표")
                .font(.system(size: 15, weight: .bold))
            Text("\(viewModel.startDate.fetchMonthDay()) ~ \(viewModel.target.previousDate.fetchMonthDay())")
                .font(.subheadline)
                .foregroundColor(Color.fontBlack)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    var calendarHeader: some View {
        HStack {
            ForEach(Weekday.allCases, id: \.self) { weekday in
                Text(weekday.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.grayLight)
            }
            .frame(minWidth: 0, maxWidth: .infinity, idealHeight: 18)
        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
    }

    var calendarBody: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
            ForEach(viewModel.emptyCalendarDays, id:\.self) { day in
                Text("")
            }
            ForEach(viewModel.calendarDays, id: \.self) { day in
                MonthlyCalculateCellView(day: day, workdays: viewModel.filterWorkday(for: day))
            }
            .frame(width: 40, height: 40)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.top, 5)
        .padding(.horizontal, 16)
    }

    func calendarBodyCell(_ day: Date) -> some View {
        Text("\(day.dayInt)")
    }

    var calendarFooter: some View {
        HStack(spacing: 10) {
            ForEach(WorkDayType.allCases, id:\.self) { workdayType in
                calendarFooterCell(workdayType)
            }
            Spacer()
        }
        .padding(.top, 35)
        .padding(.horizontal, 24)
        .padding(.bottom)
    }
    
    func calendarFooterCell(_ type: WorkDayType) -> some View {
        HStack(spacing: 4) {
            Circle()
                .foregroundColor(type.mainColor)
                .frame(width: 8, height: 8)
            Text(type.fullName)
                .font(.caption2)
                .foregroundColor(.grayMedium)
        }
    }
    
    @ViewBuilder
    var resonList: some View {
        if !viewModel.notRegularWorkdays.isEmpty {
            VStack(alignment: .leading) {
                Text("상세정보")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                ForEach(viewModel.notRegularWorkdays, id: \.self) { workday in
                    makeReasonCell(workday)
                }
            }
        }
    }
    
    var shareButton: some View {
        Button(action: {
            // TODO: - ViewModel에서 구현
        }, label: {
            Text("공유")
                .foregroundColor(Color.primary)
        })
    }
    
    func makeReasonCell(_ workday: WorkdayEntity) -> some View {
        let workday = workday
        var worktype: WorkDayType {
            return viewModel.workTypeManager.defineWorkType(workday: workday)
        }
        var startTime: String {
            return "\(viewModel.timeManager.getHour(workday.startTime)):\(viewModel.timeManager.getMinute(workday.startTime) >= 10 ? viewModel.timeManager.getMinute(workday.startTime).description : "0\(viewModel.timeManager.getMinute(workday.startTime))")"
        }
        var endTime: String {
            return "\(viewModel.timeManager.getHour(workday.endTime)):\(viewModel.timeManager.getMinute(workday.endTime) >= 10 ? viewModel.timeManager.getMinute(workday.endTime).description : "0\(viewModel.timeManager.getMinute(workday.endTime))")"
        }
        
        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(worktype.name)
                    .font(.caption2)
                    .foregroundColor(Color.backgroundWhite)
                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .background(worktype.color)
                    .cornerRadius(5)
                Spacer()
                Text(viewModel.getSpentHour(workday.endTime, workday.startTime))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.top)
            
            HStack {
                Text("\(workday.date.monthInt)월 \(workday.date.dayInt)일")
                    .fontWeight(.bold)
                Spacer()
                Text("\(startTime) ~ \(endTime)")
            }
            .foregroundColor(Color.fontBlack)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
            
            if workday.memo != nil && workday.memo != "" {
                Text(workday.memo ?? "")
                    .font(.footnote)
                    .foregroundColor(Color.grayMedium)
                    .padding(.top, -8)
                    .padding(.bottom)
            }
        }
        .padding(.horizontal)
        .background(Color.backgroundCard)
        .cornerRadius(8)
        .padding(2)
        .background(Color.backgroundStroke)
        .clipShape(RoundedRectangle(cornerRadius: 10))
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

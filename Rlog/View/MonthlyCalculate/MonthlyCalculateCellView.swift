//
//  MonthlyCalculateCellView.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/24.
//

import SwiftUI

struct MonthlyCalculateCellView: View {
    @StateObject var viewModel: MonthlyCalculateCellViewModel

    init(day: Date, workdays: [WorkdayEntity]) {
        _viewModel = StateObject(wrappedValue: MonthlyCalculateCellViewModel(day: day, workdays: workdays))
    }

    var body: some View {
        if viewModel.workdays.isEmpty {
            Text("\(viewModel.day.dayInt)")
        } else {
            ZStack {
                Text("\(viewModel.day.dayInt)")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(viewModel.workType?.color)
                    .cornerRadius(20)
                Text("\(viewModel.workHours)h")
                    .font(.caption2)
                    .foregroundColor(.grayMedium)
                    .offset(y: 28)
                    .onAppear{ }
            }
        }
    }
}

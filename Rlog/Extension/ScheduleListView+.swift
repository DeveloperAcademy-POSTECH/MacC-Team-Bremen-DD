//
//  ScheduleListView+.swift
//  Rlog
//
//  Created by 정지혁 on 2022/10/20.
//

import SwiftUI

extension ScheduleListView {
    struct StatusPicker: View {
        @EnvironmentObject var viewModel: ScheduleListViewModel
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 97)
                        .cornerRadius(20)
                        .offset(x: viewModel.setStatusPickerOffset())
                    HStack(spacing: 0) {
                        ForEach(viewModel.scheduleCases, id: \.self) { schedule in
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 176 / 2)
                                Text(schedule.rawValue)
                                    .font(.caption2)
                                    .fontWeight(viewModel.setStatusPickerTextWeight(compareCase: schedule))
                                    .foregroundColor(viewModel.setStatusPickerForegroundColor(compareCase: schedule))
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.selectedScheduleCase = schedule
                                        }
                                    }
                            }
                        }
                    }
                }
                .cornerRadius(20)
            }
        }
    }
}

//
//  ScheduleListView+.swift
//  Rlog
//
//  Created by 정지혁 on 2022/10/20.
//

import SwiftUI

extension ScheduleListView {
    struct CustomPicker: View {
        @EnvironmentObject var viewModel: ScheduleListViewModel
        @Binding var selectedScheduleCase: ScheduleCase
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 97)
                        .cornerRadius(20)
                        .offset(x: viewModel.setCustomPickerOffset(currentCase: selectedScheduleCase))
                    HStack(spacing: 0) {
                        ForEach(viewModel.scheduleCases, id: \.self) { schedule in
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: viewModel.setCustomPickerRectangleWidth(currentCase: selectedScheduleCase, compareCase: schedule))
                                Text(schedule.rawValue)
                                    .font(.caption2)
                                    .fontWeight(viewModel.setCustomPickerTextWeight(currentCase: selectedScheduleCase, compareCase: schedule))
                                    .foregroundColor(viewModel.setCustomPickerForegroundColor(currentCase: selectedScheduleCase, compareCase: schedule))
                                    .onTapGesture {
                                        withAnimation {
                                            selectedScheduleCase = schedule
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
